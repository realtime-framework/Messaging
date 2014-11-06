// -------------------------------------
//  Domain	: Realtime.co
//  Author	: Nicholas Ventimiglia
//  Product	: Messaging and Storage
//  Copyright (c) 2014 IBT  All rights reserved.
//  -------------------------------------

using UnityEngine;

namespace RealtimeDemos.TerminalConsole.Commands
{
    /// <summary>
    /// Extends the console with 'about me' command
    /// </summary>
    [AddComponentMenu("Realtime/Demos/Terminal/Clear")]
    public class ClearCommand : MonoBehaviour
    {
        void Awake()
        {
            Terminal.Add(new TerminalCommand
            {
                Label = "Clear",
                Method = () => Terminal.Clear()
            });
        }

    }
}
