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
    [AddComponentMenu("Realtime/Demos/Terminal/About")]
    public class AboutCommand : MonoBehaviour
    {
        [Multiline]
        public string Text =
        "\r\n"+
        "Terminal by Nicholas Ventimiglia 2013 \r\n" +
        "Part of the Foundation Toolkit \r\n" +
        "www.AvariceOnline.Com \r\n";

        void Awake()
        {
            Terminal.Add(new TerminalCommand
            {
                Label = "About",
                Method = () => Terminal.Log(Text)
            });
        }

    }
}
