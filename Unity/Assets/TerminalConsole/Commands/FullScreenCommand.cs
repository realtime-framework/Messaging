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
    /// Extends the terminal with 'Full Screen' command
    /// </summary>
    [AddComponentMenu("Realtime/Demos/Terminal/FullScreen")]
    public class FullScreenCommand : MonoBehaviour
    {
        void Awake()
        {
#if UNITY_STANDALONE
            Terminal.Add(new TerminalCommand
            {
                Label = "Full Screen",
                Method = () =>
                {
                    Screen.fullScreen = !Screen.fullScreen;
                }
            });
#endif
        }
    }
}