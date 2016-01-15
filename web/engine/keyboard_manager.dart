library engine.keyboard_manager;

import 'dart:html';

enum Commands
{
  MoveLeft,
  MoveRight,
  MoveUp,
  MoveDown,
  MoveForward,
  MoveBackward,
  RollUp,
  RollDown,
  YawUp,
  YawDown,
  PitchUp,
  PitchDown
}

enum Keys
{
  W, A, S, D, Q, E, Z, X,
  Ctrl, Space,
  UpArrow, LeftArrow, DownArrow, RightArrow, 
  NumPad1, NumPad2, NumPad3, NumPad4, NumPad5, NumPad6   
}

class KeyboardManager
{
  int keyCode;
  Map<Commands, Keys> commandMap = new Map<Commands, Keys>();
  Map<int, Keys> keyMap = new Map<int, Keys>();
  Map<Keys, bool> keyState = new Map<Keys, bool>();
  
  KeyboardManager()
  {
    window.onKeyDown.listen(this.onKeyDown);
    window.onKeyUp.listen(this.onKeyUp);
    keyMap[87] = Keys.W;
    keyMap[65] = Keys.A;
    keyMap[83] = Keys.S;
    keyMap[68] = Keys.D;
    keyMap[37] = Keys.LeftArrow;
    keyMap[38] = Keys.UpArrow;
    keyMap[39] = Keys.RightArrow;
    keyMap[40] = Keys.DownArrow;
    keyMap[97] = Keys.NumPad1;
    keyMap[98] = Keys.NumPad2;
    keyMap[99] = Keys.NumPad3;
    keyMap[100] = Keys.NumPad4;
    keyMap[101] = Keys.NumPad5;
    keyMap[102] = Keys.NumPad6;
    keyMap[81] = Keys.Q;
    keyMap[69] = Keys.E;
    keyMap[17] = Keys.Ctrl;
    keyMap[32] = Keys.Space;
    keyMap[90] = Keys.Z;
    keyMap[88] = Keys.X;
    
    commandMap[Commands.MoveUp] = Keys.Z;
    commandMap[Commands.MoveDown] = Keys.X;
    commandMap[Commands.YawUp] = Keys.D;
    commandMap[Commands.YawDown] = Keys.A;
    commandMap[Commands.PitchUp] = Keys.W;
    commandMap[Commands.PitchDown] = Keys.S;
    commandMap[Commands.RollUp] = Keys.Q;
    commandMap[Commands.RollDown] = Keys.E;
    commandMap[Commands.MoveForward] = Keys.UpArrow;
    commandMap[Commands.MoveBackward] = Keys.DownArrow;
    commandMap[Commands.MoveLeft] = Keys.LeftArrow;
    commandMap[Commands.MoveRight] = Keys.RightArrow;
    
    // Make the default state false
    List<Keys> keys = Keys.values;
    for (int i = 0; i < keys.length; i++)
    {
      keyState[keys[i]] = false;
    }
  }
  
  bool IsCommandPressed(Commands command)
  {
    if (commandMap.containsKey(command))
    {
      return keyState[commandMap[command]];
    }
    return false;
  }
  
  void onKeyDown(KeyboardEvent e)
  {
    this.keyCode = e.keyCode;
    if (keyMap.containsKey(e.keyCode))
    {
      keyState[keyMap[e.keyCode]] = true;
    }
  }
  
  void onKeyUp(KeyboardEvent e)
  {
    this.keyCode = 0;
    if (keyMap.containsKey(e.keyCode))
    {
      keyState[keyMap[e.keyCode]] = false;
    }
  }
}