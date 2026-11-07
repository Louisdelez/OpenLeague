package system.serializers.eden
{
   public function info(param1:Boolean = false, param2:Boolean = false):String
   {
      var _loc3_:String = "----------------------------------------------------------------";
      var _loc4_:String = "\n";
      var _loc5_:String = "eden";
      var _loc6_:String = "ECMASCript data exchange notation";
      var _loc7_:Version = new Version(0,1);
      var _loc8_:String = "";
      if(!param1 && Boolean(config.verbose))
      {
         param1 = true;
      }
      if(param1)
      {
         _loc8_ += "{sep}{crlf}";
         _loc8_ = _loc8_ + "{name}: {fullname} v{version}{crlf}";
         _loc8_ = _loc8_ + "{sep}";
      }
      else
      {
         _loc8_ += "{name} v{version}";
      }
      if(param2)
      {
         _loc8_ += "{crlf}config:";
         _loc8_ = _loc8_ + "{config}{crlf}";
         _loc8_ = _loc8_ + "{sep}";
      }
      return Strings.format(_loc8_,{
         "sep":_loc3_,
         "crlf":_loc4_,
         "name":_loc5_,
         "fullname":_loc6_,
         "version":_loc7_,
         "config":eden.serialize(config)
      });
   }}

