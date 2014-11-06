// -------------------------------------
//  Domain	: Realtime.co
//  Author	: Nicholas Ventimiglia
//  Product	: Messaging and Storage
//  Copyright (c) 2014 IBT  All rights reserved.
//  -------------------------------------

using System;
using System.Linq;
using UnityEngine;

namespace RealtimeDemos.TerminalConsole
{
    /// <summary>
    /// renders the Terminal using classical OnGUI
    /// </summary>
    [AddComponentMenu("Realtime/Demos/Terminal/TerminalGUI")]
    public class TerminalGUI : MonoBehaviour
    {
        /// <summary>
        /// skin to use
        /// </summary>
        public GUISkin MySkin;

        /// <summary>
        /// Items
        /// </summary>
        public bool ReverseSort = true;

        public float MarginTop = 32;
        public float MarginBottom = 32;
        public float MarginLeft = 32;
        public float MarginRight = 32;

        public float Padding = 4;

        public float CommandWidth = 180;

        public bool DoDontDestoryOnLoad = true;
        
        // submit
        string _inputValue = string.Empty;
        // items
        Vector2 _scrollItems = Vector2.zero;
        // command menu
        Vector2 _scrollCmdMenu = Vector2.zero;
        //items
        TerminalItem[] _items;

        public bool IsVisible = true;
        public KeyCode VisiblityKey = KeyCode.BackQuote;

        void Awake()
        {
            Update();
            Application.RegisterLogCallback(Handler);
            Debug.Log("Console Ready");

            if (DoDontDestoryOnLoad)
                DontDestroyOnLoad(gameObject);

        }

        private void Handler(string condition, string stackTrace, LogType type)
        {
            switch (type)
            {
                    case LogType.Error:
                    case LogType.Exception:
                    Terminal.LogError(condition);
                    break;
                    case LogType.Warning:
                    Terminal.LogWarning(condition);
                    break;
                    case LogType.Log:
                    case LogType.Assert:
                    Terminal.Log(condition);
                    break;
            }
        }

        void Update()
        {
            _items = ReverseSort
                            ? Terminal.Items.AsEnumerable().Reverse().ToArray()
                            : Terminal.Items.ToArray();

            if (Input.GetKeyUp(VisiblityKey))
            {
                IsVisible = !IsVisible;
            }

        }

        void OnGUI()
        {
            if (!IsVisible)
                return;

            GUI.skin = MySkin;

            GUILayout.BeginHorizontal();
            GUILayout.Space(MarginLeft);

            // left side
            GUILayout.BeginVertical(
                GUILayout.MaxWidth(Screen.width - (MarginRight + CommandWidth + Padding)),
                GUILayout.MaxHeight(Screen.height - (MarginTop +  Padding))
                );
            GUILayout.Space(MarginTop);

            // top menu
            GUILayout.BeginHorizontal();


            if (Event.current.keyCode == KeyCode.Return)
            {
                DoSend();
            }
            else
            {
                _inputValue = GUILayout.TextField(_inputValue, GUILayout.Width(256));
            }

            if (GUILayout.Button("Send"))
            {
                DoSend();
            }

            if (GUILayout.Button("Clear"))
            {
                DoClear();
            }


            GUILayout.EndHorizontal();
            GUILayout.Space(Padding);

            // end menu

            _scrollItems = GUILayout.BeginScrollView(_scrollItems,
                false,
                true,
                GUILayout.ExpandHeight(true),
                GUILayout.ExpandWidth(true));


            foreach (var item in _items)
            {
                GUI.color = item.Color;
                GUILayout.Label(item.Formatted, GUILayout.ExpandHeight(false));
            }

            GUI.color = GUI.contentColor;

            GUILayout.EndScrollView();

            GUILayout.EndVertical();
            GUILayout.Space(Padding);
            //end left side

            // menu
            GUILayout.BeginVertical(
                GUILayout.Width(CommandWidth + MarginRight));
            GUILayout.Space(MarginTop);

            GUILayout.BeginHorizontal(
                GUILayout.MaxHeight(Screen.height - (MarginTop + MarginBottom)),
                GUILayout.Width(CommandWidth+ MarginRight));
          
            _scrollCmdMenu = GUILayout.BeginScrollView(_scrollCmdMenu,
                false,
                true,
                GUILayout.MaxWidth(CommandWidth),
                GUILayout.ExpandHeight(true));

            foreach (var item in Terminal.Commands)
            {
                if (GUILayout.Button(item.Label))
                {
                    item.Method.Invoke();
                }
            }

            GUILayout.EndScrollView();
            GUILayout.Space(MarginRight);
            GUILayout.EndHorizontal();
            GUILayout.Space(MarginBottom);
            GUILayout.EndVertical();

            //end menu

            GUILayout.EndHorizontal();
        }

        public void DoSend()
        {
            _inputValue = _inputValue.Replace(Environment.NewLine, "");

            if (string.IsNullOrEmpty(_inputValue))
                return;

            Terminal.Submit(_inputValue);

            _inputValue = string.Empty;
        }

        public void DoClear()
        {
            Terminal.Clear();
        }
    }
}