#ifndef libortc_h__dlist
#define libortc_h__dlist


typedef struct ortc_dnode {
  char* id;
  char* val1;
  char* val2;
  int num;
  void (*callback)();
  struct ortc_dnode *next;
} ortc_dnode;

typedef struct {
  ortc_dnode *first;
  ortc_dnode *last;
  int count;
  int isBlocked;
} ortc_dlist;

ortc_dlist* _ortc_dlist_init();
void _ortc_dlist_free(ortc_dlist *dlist);
//struct ortc_dnode * _ortc_dlist_create_dnode(char* id, char* val);
void _ortc_dlist_insert(ortc_dlist* dl, char* id, char* val1, char* val2, int num, void (*cb)());
void _ortc_dlist_print(ortc_dlist* dl);
ortc_dnode* _ortc_dlist_search(ortc_dlist* dl, char* id);
ortc_dnode* _ortc_dlist_searchEx(ortc_dlist* dl, char* id, int num);
void _ortc_dlist_delete(ortc_dlist* dl, char* id);
struct ortc_dnode* _ortc_dlist_take_first(ortc_dlist* dl);
void _ortc_dlist_deleteEx(ortc_dlist* dl, char* id, int num);
void _ortc_dlist_clear(ortc_dlist* dl);
void _ortc_dlist_delete_first(ortc_dlist* dl);
void _ortc_dlist_free_dnode(ortc_dnode *n);
#endif  // libortc_h__dlist
