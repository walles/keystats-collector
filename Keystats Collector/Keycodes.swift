import Carbon.HIToolbox.Events

func eventFlagMaskForKeycode(_ keycode: Int) -> Int32 {
  switch keycode {
  case kVK_Command: return NX_DEVICELCMDKEYMASK;
  case kVK_Shift: return NX_DEVICELSHIFTKEYMASK;
  case kVK_CapsLock: return NX_ALPHASHIFTMASK;
  case kVK_Option: return NX_DEVICELALTKEYMASK;
  case kVK_Control: return NX_DEVICELCTLKEYMASK;
  case kVK_RightCommand: return NX_DEVICERCMDKEYMASK;
  case kVK_RightShift: return NX_DEVICERSHIFTKEYMASK;
  case kVK_RightOption: return NX_DEVICERALTKEYMASK;
  case kVK_RightControl: return NX_DEVICERCTLKEYMASK;
  case kVK_Function: return NX_SECONDARYFNMASK;
  default:
    return 0
  }
}
