// -------------------------------------
//  Domain	: Realtime.co
//  Author	: Nicholas Ventimiglia
//  Product	: Messaging and Storage
//  Copyright (c) 2014 IBT  All rights reserved.
//  -------------------------------------

using UnityEngine;

namespace RealtimeDemos.TerminalConsole
{
    /// <summary>
    /// An optional setup script for the Terminal system.
    /// Applies the color scheme to the context.
    /// </summary>
    [AddComponentMenu("Realtime/Demos/Terminal/TerminalSetup")]
    public class TerminalSetup : MonoBehaviour
    {
        public Color LogColor = Color.white;
        public Color WarningColor = Color.yellow;
        public Color ErrorColor = Color.red;

        public Color SuccessColor = Color.green;
        public Color InputColor = Color.cyan;
        public Color ImportantColor = Color.yellow;
        
        public void Awake()
        {
            Terminal.Instance.LogColor = LogColor;
            Terminal.Instance.WarningColor = WarningColor;
            Terminal.Instance.ErrorColor = ErrorColor;
            Terminal.Instance.SuccessColor = SuccessColor;
            Terminal.Instance.InputColor = InputColor;
            Terminal.Instance.ImportantColor = ImportantColor;
        }
    }
}