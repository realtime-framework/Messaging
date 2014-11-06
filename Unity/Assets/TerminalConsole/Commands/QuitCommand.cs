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
    /// exit app command
    /// </summary>
    [AddComponentMenu("Realtime/Demos/Terminal/Quit")]
    public class QuitCommand : MonoBehaviour
    {
        void Awake()
        {


#if UNITY_EDITOR
             Terminal.Add(new TerminalCommand
            {
                Label = "Quit",
                Method = () =>
                {
                    UnityEditor.EditorApplication.isPlaying = false;
                }
            });
#elif UNITY_STANDALONE || UNITY_ANDROID
             Terminal.Add(new TerminalCommand
            {
                Label = "Quit",
                Method = () => Application.Quit()
            });
#endif

        }
    }
}