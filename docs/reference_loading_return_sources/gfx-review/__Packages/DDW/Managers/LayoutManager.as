class DDW.Managers.LayoutManager
{
   var _class = "LayoutManager";
   function LayoutManager()
   {
   }
   static function getLayout(libraryName)
   {
      var _loc3_ = {};
      var _loc4_ = _root.attachMovie(libraryName,"temp_" + libraryName,0);
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(_loc4_ != null)
      {
         _loc4_._alpha = 0;
         for(var s in _loc4_)
         {
            _loc5_ = getFirstDigitLocation(s);
            if(_loc5_ > -1)
            {
               _loc6_ = s.substring(0,_loc5_);
               _loc7_ = _global.parseInt(s.substring(_loc5_));
               if(_loc3_[_loc6_] == null)
               {
                  _loc3_[_loc6_] = [];
               }
               _loc3_[_loc6_][_loc7_] = getMetrics(_loc4_[s]);
            }
            else
            {
               if(_loc3_[s] == null)
               {
                  _loc3_[s] = [];
               }
               _loc3_[s][0] = getMetrics(_loc4_[s]);
            }
         }
         _loc4_.removeMovieClip();
         _loc4_ = null;
      }
      return _loc3_;
   }
   static function getMetrics(obj)
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(typeof obj == "movieclip")
      {
         _loc3_ = new DDW.Utils.Metrics(obj._x,obj._y,obj._width,obj._height,obj._alpha);
      }
      else if(typeof obj == "object" && obj.text != null)
      {
         _loc4_ = TextField(obj);
         _loc5_ = _loc4_.getNewTextFormat();
         _loc3_ = new DDW.Utils.TextMetrics(_loc4_._x,_loc4_._y,_loc4_._width,_loc4_._height,_loc4_.text,_loc5_.align,_loc5_.bold,_loc5_.font,_loc5_.size,_loc5_.leading,_loc5_.color);
      }
      return _loc3_;
   }
   static function getFirstDigitLocation(s)
   {
      var _loc3_ = -1;
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < s.length)
      {
         _loc5_ = ord(s.charAt(_loc4_));
         if(_loc5_ >= 48 && _loc5_ <= 57)
         {
            _loc3_ = _loc4_;
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   function toString()
   {
      return this._class;
   }
}
