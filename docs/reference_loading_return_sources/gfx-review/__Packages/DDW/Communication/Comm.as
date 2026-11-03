class DDW.Communication.Comm
{
   function Comm()
   {
   }
   static function send(msg, arg)
   {
      var _loc4_;
      if(msg != null && (msg != "Release_" && (msg != "RollOver_" && msg != "RollOut_")))
      {
         _loc4_ = msg.indexOf("#");
         if(_loc4_ > -1 && (arg == null || arg == ""))
         {
            arg = msg.substring(_loc4_ + 1);
            msg = msg.substring(0,_loc4_);
         }
         if(msg == "" || msg == "Press_")
         {
            msg = "backgroundClick";
         }
         if(DDW.Managers.GameManager.getInstance().isGfx)
         {
            if(arg != null)
            {
               fscommand(msg,arg);
            }
            else
            {
               fscommand(msg,"");
            }
         }
         else if(arg != null)
         {
            trace("\'" + msg + "\', \'" + arg + "\'");
         }
         else
         {
            trace("\'" + msg + "\'");
         }
      }
   }
}
