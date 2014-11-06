# Foundation Terminal (v3.0)

Nicholas Ventimiglia | AvariceOnline.com

## Terminal Console for ingame debuging

The goal of this library to provide a UI for testing low level libraries and debuging ingame

 - Log many message types with color coding
 - Hooks into Debug.Log
 - A command button bar for testing methods or 'god mode' commands (console commands)
 - A text input with optional input handling (text processors)
 - Hide and close with the ` command
 - Model / View design

 ## Setup

Attach the TerminalSetup, TerminalGUI and any Command / Input extensions to gameobjects.

## Example Usage

```c#

// Write
	Terminal.Log("blag blah");
	Terminal.LogError("blag blah");
	Terminal.LogSuccess("blag blah");
	Terminal.LogWarning("blag blah");
	Terminal.LogImportant("blag blah");

// Register button commands. (Do this in Awake)

	Terminal.Add(new TerminalCommand
		{
			Label = "Main",
			Method = MainTest
		});

	void MainTest()
	{
	   // Run When Clicked
	}

// Register new Text Processors (invoked when text is submitted)

	Terminal.Add(new TerminalInterpreter
		{
			Label = "Chat",
			Method = ChatExample
		});

	void ChatExample(string text)
	{
	   // Run When inputted
	}
```