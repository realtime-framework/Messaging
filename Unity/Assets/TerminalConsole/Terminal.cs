// -------------------------------------
//  Domain	: Realtime.co
//  Author	: Nicholas Ventimiglia
//  Product	: Messaging and Storage
//  Copyright (c) 2014 IBT  All rights reserved.
//  -------------------------------------

using System;
using System.Collections.Generic;
using UnityEngine;

namespace RealtimeDemos.TerminalConsole
{
    #region sub objects

    /// <summary>
    /// Message Formatting
    /// </summary>
    public enum TerminalType
    {
        Log,
        Warning,
        Error,
        Exception,
        Success,
        Important,
        Input,
    }

    /// <summary>
    /// A Terminal line item
    /// </summary>
    public struct TerminalItem
    {
        readonly string _text;
        public string Text
        {
            get { return _text; }
        }

        readonly string _formatted;
        public string Formatted
        {
            get { return _formatted; }
        }

        readonly TerminalType _type;
        public TerminalType Type
        {
            get { return _type; }
        }

        readonly Color _color;
        public Color Color
        {
            get { return _color; }
        }

        public TerminalItem(TerminalType type, string text)
        {
            _text = text;
            _type = type;
            switch (_type)
            {
                case TerminalType.Warning:
                    _formatted = string.Format("<< {0}", text);
                    _color = Terminal.Instance.WarningColor;
                    break;
                case TerminalType.Error:
                    _formatted = string.Format("<< {0}", text);
                    _color = Terminal.Instance.ErrorColor;
                    break;
                case TerminalType.Success:
                    _formatted = string.Format("<< {0}", text);
                    _color = Terminal.Instance.SuccessColor;
                    break;
                case TerminalType.Important:
                    _formatted = string.Format("<< {0}", text);
                    _color = Terminal.Instance.ImportantColor;
                    break;
                case TerminalType.Input:
                    _formatted = string.Format(">> {0}", text);
                    _color = Terminal.Instance.InputColor;
                    break;
                default:
                    _formatted = text;
                    _color = Terminal.Instance.LogColor;
                    break;
            }
        }
    }

    /// <summary>
    /// For processing Text input
    /// </summary>
    public class TerminalInterpreter
    {
        public string Label;
        public Action<string> Method;
    }

    /// <summary>
    /// Button to add to the menu
    /// </summary>
    public class TerminalCommand
    {
        public string Label;
        public Action Method;
    }
    #endregion


    /// <summary>
    /// The Terminal Model.
    /// </summary>
    public class Terminal
    {
        #region static
        public static readonly Terminal Instance = new Terminal();
        #endregion

        #region props / fields

        // Default color of the standard display text.

        public Color LogColor = Color.white;
        public Color WarningColor = Color.yellow;
        public Color ErrorColor = Color.red;
        public Color SuccessColor = Color.green;
        public Color InputColor = Color.green;
        public Color ImportantColor = Color.cyan;

        public static readonly List<TerminalItem> Items = new List<TerminalItem>();
        public static readonly List<TerminalCommand> Commands = new List<TerminalCommand>();
        public static readonly List<TerminalInterpreter> Interpreters = new List<TerminalInterpreter>();

        public static object SyncRoot = new object();

        #endregion

        /// <summary>
        /// Add Command
        /// </summary>
        public static void Add(TerminalCommand arg)
        {
            lock (SyncRoot)
            {
                Commands.Add(arg);
            }
        }

        /// <summary>
        /// Add Interpreter
        /// </summary>
        public static void Add(TerminalInterpreter arg)
        {
            lock (SyncRoot)
            {
                Interpreters.Add(arg);
            }
        }


        /// <summary>
        /// write only
        /// </summary>
        public static void Add(TerminalItem message)
        {
            lock (SyncRoot)
            {
                Items.Add(message);
            }
        }

        /// <summary>
        /// write only
        /// </summary>
        public static void Add(object message, TerminalType type)
        {
            Add(new TerminalItem(type, message.ToString()));
        }

        /// <summary>
        /// write only
        /// </summary>
        public static void Log(object message)
        {
            Add(new TerminalItem(TerminalType.Log, message.ToString()));
        }

        /// <summary>
        /// write only
        /// </summary>
        public static void LogError(object message)
        {
            Add(new TerminalItem(TerminalType.Error, message.ToString()));
        }

        /// <summary>
        /// write only
        /// </summary>
        public static void LogWarning(object message)
        {
            Add(new TerminalItem(TerminalType.Warning, message.ToString()));
        }

        /// <summary>
        /// write only
        /// </summary>
        public static void LogSuccess(object message)
        {
            Add(new TerminalItem(TerminalType.Success, message.ToString()));
        }

        /// <summary>
        /// write only
        /// </summary>
        public static void LogImportant(object message)
        {
            Add(new TerminalItem(TerminalType.Important, message.ToString()));
        }

        /// <summary>
        /// write only
        /// </summary>
        public static void LogInput(object message)
        {
            Add(new TerminalItem(TerminalType.Input, message.ToString()));
        }


        /// <summary>
        /// Input for a command
        /// </summary>
        /// <param name="message"></param>
        public static void Submit(string message)
        {
            if (string.IsNullOrEmpty(message))
            {
                LogInput(string.Empty);
                return;
            }

            message = message.Trim();

            Add(new TerminalItem(TerminalType.Input, message));

            lock (SyncRoot)
            {
                foreach (var interpreter in Interpreters)
                {
                    interpreter.Method.Invoke(message);
                }
            }
        }

        /// <summary>
        /// clear writes
        /// </summary>
        public static void Clear()
        {
            lock (SyncRoot)
            {
                Items.Clear();
            }
        }
    }
}