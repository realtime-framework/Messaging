#include "dlist.h"
#include "libortc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

ortc_dlist* _ortc_dlist_init(){
  ortc_dlist *dl = (ortc_dlist*)malloc(sizeof(ortc_dlist));
  if(dl == NULL){
    fprintf(stderr, "malloc ortc_dlist_init failed\n");
    exit(EXIT_FAILURE);
  }
  dl->first = NULL;
  dl->last = NULL;
  dl->count = 0;
  dl->isBlocked = 0;
  return dl;
}

void _ortc_dlist_free_dnode(ortc_dnode *n){
  free(n->id);
  free(n->val1);
  free(n->val2);
  free(n);
}

void _ortc_dlist_free(ortc_dlist *dl){
  ortc_dnode *ptr = (ortc_dnode*)dl->first;
  ortc_dnode *t;
  while(ptr != NULL){
    t = ptr;
    ptr = (ortc_dnode*)ptr->next;
    _ortc_dlist_free_dnode(t);
  }
  free(dl);
}

ortc_dnode * _ortc_dlist_create_dnode(char* id, char* val1, char* val2, int num, void (*cb)()){
  ortc_dnode *ret;
  if(id == NULL)
    return NULL;
  ret = (ortc_dnode*)malloc(sizeof(ortc_dnode));
  if(ret == NULL){
    fprintf(stderr, "malloc ortc_dlist_craete_dnode failed\n");
    exit(EXIT_FAILURE);
  }
  ret->id = strdup(id);  
  ret->val1 = (val1 == NULL) ? NULL : strdup(val1);
  ret->val2 = (val2 == NULL) ? NULL : strdup(val2);
  ret->num = num;
  ret->callback = cb;
  ret->next = NULL;
  if(ret->id == NULL)
    return NULL;
  return ret;
}

void _ortc_dlist_insert(ortc_dlist* dl, char* id, char* val1, char* val2, int num, void (*cb)()){
  ortc_dnode *n = (ortc_dnode*)_ortc_dlist_create_dnode(id, val1, val2, num, cb);
  if(n == NULL) return;
  if(dl->first == NULL){
    dl->first = (ortc_dnode*)n;
  }
  if(dl->last != NULL)
    dl->last->next = (ortc_dnode*)n;
  dl->last = (ortc_dnode*)n;
  dl->count++;
}

void _ortc_dlist_print(ortc_dlist* dl){
  struct ortc_dnode *ptr = dl->first;
  while(ptr != NULL){
    printf("::: (%s) %s :: %s :: %d\n", ptr->id, ptr->val1, ptr->val2, ptr->num);
    ptr = ptr->next;
  }
}

ortc_dnode* _ortc_dlist_search(ortc_dlist* dl, char* id){
  struct ortc_dnode *ptr = dl->first;
  while(ptr != NULL){
    if(strcmp(id, ptr->id) == 0)
      return ptr;
    ptr = ptr->next;
  }
  return NULL;
}

struct ortc_dnode* _ortc_dlist_searchEx(ortc_dlist* dl, char* id, int num){
  struct ortc_dnode *ptr = dl->first;
  while(ptr != NULL){
    if(strcmp(id, ptr->id) == 0 && num == ptr->num)
      return ptr;
    ptr = ptr->next;
  }
  return NULL;
}

void _ortc_dlist_delete(ortc_dlist* dl, char* id){
  struct ortc_dnode *prev = dl->first;
  if(strcmp(dl->first->id, id) == 0){
      struct ortc_dnode *t = dl->first;      
      dl->first = dl->first->next;
      if(dl->last == t)
	dl->last = NULL;
      _ortc_dlist_free_dnode(t);
      dl->count--;
  } else {
    struct ortc_dnode *ptr = dl->first->next;
    while(ptr != NULL){
      if(strcmp(id, ptr->id) == 0){
	prev->next = ptr->next;
	if(dl->last == ptr)
	  dl->last = prev;	
	_ortc_dlist_free_dnode(ptr);
	dl->count--;
      }
      prev = ptr;
      ptr = ptr->next;      
    }
  }
}

struct ortc_dnode* _ortc_dlist_take_first(ortc_dlist* dl){
  ortc_dnode *t;
  if(dl->first == NULL)
    return NULL;
  t = dl->first;
  dl->first = dl->first->next;
  if(dl->last == t)
    dl->last = NULL;
  dl->count--;
  return t;
}

void _ortc_dlist_delete_first(ortc_dlist* dl){
  ortc_dnode *t = _ortc_dlist_take_first(dl);
  _ortc_dlist_free_dnode(t);
}

void _ortc_dlist_deleteEx(ortc_dlist* dl, char* id, int num){
  ortc_dnode *prev = dl->first;
  ortc_dnode *t, *ptr;
  if(strcmp(dl->first->id, id) == 0 && dl->first->num == num){
      t = dl->first;      
      dl->first = dl->first->next;
      if(dl->last == t)
	dl->last = NULL;
      _ortc_dlist_free_dnode(t);
      dl->count--;
  } else {
    ptr = dl->first->next;
    while(ptr != NULL){
      if(strcmp(id, ptr->id) == 0 && num == ptr->num){
	prev->next = ptr->next;
	if(dl->last == ptr)
	  dl->last = prev;	
	_ortc_dlist_free_dnode(ptr);
	dl->count--;
      }
      prev = ptr;
      ptr = ptr->next;      
    }
  }
}

void _ortc_dlist_clear(ortc_dlist* dl){
  ortc_dnode *ptr = dl->first;
  ortc_dnode *t;
  while(ptr != NULL){
    t = ptr;
    ptr = ptr->next;
    _ortc_dlist_free_dnode(t);
  }
  dl->first = NULL;
  dl->last = NULL;
  dl->count = 0;
}
