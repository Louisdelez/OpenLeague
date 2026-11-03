class org.flashdevelop.utils.FlashViewer
{
   static var limit = 1000;
   static var counter = 0;
   static var aborted = false;
   function FlashViewer()
   {
   }
   static function trace(value, level)
   {
      counter++;
      var _loc4_;
      if(counter > limit && !aborted)
      {
         aborted = true;
         _loc4_ = new String("FlashViewer aborted. You have reached the limit of maximum messages.");
         fscommand("trace","3:" + _loc4_);
      }
      if(!aborted)
      {
         if(!_global.isNaN(level))
         {
            fscommand("trace",level + ":" + value);
         }
         else
         {
            fscommand("trace",value.toString());
         }
      }
   }
   static function mtrace(value, method, path, line)
   {
      if(path.charAt(1) != ":")
      {
         path = "~/" + path;
      }
      var _loc6_ = path + ":" + line + ":" + value;
      trace(_loc6_);
   }
}
