class DDW.Utils.DrawingUtils
{
   function DrawingUtils()
   {
   }
   static function setHtmlText(s, tf, format)
   {
      tf.selectable = false;
      tf.embedFonts = true;
      tf.multiline = true;
      tf.wordWrap = true;
      tf.antiAliasType = "advanced";
      tf.html = true;
      tf.htmlText = s;
   }
   static function setInputTextFormat(tf, format)
   {
      tf.type = "input";
      tf.background = true;
      tf.backgroundColor = 16777215;
      tf.selectable = true;
      tf.embedFonts = true;
      tf.antiAliasType = "advanced";
      tf.html = false;
      tf.setTextFormat(format);
   }
   static function formatMsAsSeconds(ms)
   {
      ms = Math.floor(ms / 100);
      var _loc3_ = ms.toString();
      _loc3_ = _loc3_.substr(0,_loc3_.length - 1) + "." + _loc3_.substr(_loc3_.length - 1);
      if(_loc3_.indexOf(".") == 0)
      {
         _loc3_ = "0" + _loc3_;
      }
      return _loc3_;
   }
   static function drawRect(clip, rect, color, alpha, lineWidth, lineColor, lineAlpha)
   {
      var _loc9_;
      var _loc10_;
      if(clip != null)
      {
         if(color != null)
         {
            _loc9_ = alpha != null ? alpha : 100;
            clip.beginFill(color,_loc9_);
         }
         else
         {
            clip.endFill();
         }
         if(lineWidth != null && lineWidth != 0)
         {
            _loc10_ = lineAlpha != null ? lineAlpha : 100;
            clip.lineStyle(lineWidth,lineColor,_loc10_);
         }
         else
         {
            clip.lineStyle(0,0,0);
         }
         clip.moveTo(rect.left,rect.top);
         clip.lineTo(rect.right,rect.top);
         clip.lineTo(rect.right,rect.bottom);
         clip.lineTo(rect.left,rect.bottom);
         clip.lineTo(rect.left,rect.top);
         if(color != null)
         {
            clip.endFill();
         }
      }
   }
   static function drawRoundedRect(clip, rect, roundness, color, alpha, lineWidth, lineColor, lineAlpha)
   {
      var _loc10_;
      var _loc11_;
      if(clip != null)
      {
         if(color != null)
         {
            _loc10_ = alpha != null ? alpha : 100;
            clip.beginFill(color,_loc10_);
         }
         if(lineWidth != null && lineWidth != 0)
         {
            _loc11_ = lineAlpha != null ? lineAlpha : 100;
            clip.lineStyle(lineWidth,lineColor,_loc11_);
         }
         drawRounded(clip,rect,roundness);
         if(color != null)
         {
            clip.endFill();
         }
      }
   }
   static function drawRoundedBorder(clip, innerRect, outerRect, roundness, color, alpha, lineWidth, lineColor, lineAlpha)
   {
      var _loc11_;
      var _loc12_;
      if(clip != null)
      {
         if(color != null)
         {
            _loc11_ = alpha != null ? alpha : 100;
            clip.beginFill(color,_loc11_);
         }
         if(lineWidth != null && lineWidth != 0)
         {
            _loc12_ = lineAlpha != null ? lineAlpha : 100;
            clip.lineStyle(lineWidth,lineColor,_loc12_);
         }
         drawRounded(clip,innerRect,roundness);
         drawRounded(clip,outerRect,roundness);
         if(color != null)
         {
            clip.endFill();
         }
      }
   }
   static function drawRounded(clip, rect, roundness)
   {
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(clip != null)
      {
         _loc5_ = rect.width + rect.left;
         _loc6_ = rect.height + rect.top;
         _loc7_ = roundness * 0.144;
         clip.moveTo(rect.left + roundness,rect.top);
         clip.lineTo(_loc5_ - roundness,rect.top);
         clip.curveTo(_loc5_ - _loc7_,rect.top + _loc7_,_loc5_,rect.top + roundness);
         clip.lineTo(_loc5_,_loc6_ - roundness);
         clip.curveTo(_loc5_ - _loc7_,_loc6_ - _loc7_,_loc5_ - roundness,_loc6_);
         clip.lineTo(rect.left + roundness,_loc6_);
         clip.curveTo(rect.left + _loc7_,_loc6_ - _loc7_,rect.left,_loc6_ - roundness);
         clip.lineTo(rect.left,rect.top + roundness);
         clip.curveTo(rect.left + _loc7_,rect.top + _loc7_,rect.left + roundness,rect.top);
      }
   }
   static function drawWedge(clip, x, y, startAngle, arc, xRadius, yRadius, color, alpha, lineWidth, lineColor, lineAlpha)
   {
      var _loc14_;
      var _loc15_;
      var _loc16_;
      var _loc21_;
      var _loc17_;
      var _loc18_;
      var _loc19_;
      var _loc22_;
      var _loc23_;
      var _loc28_;
      var _loc20_;
      var _loc24_;
      var _loc25_;
      var _loc26_;
      var _loc27_;
      if(clip != null && arc != 0)
      {
         if(color != null)
         {
            _loc14_ = alpha != null ? alpha : 100;
            clip.beginFill(color,_loc14_);
         }
         _loc15_ = false;
         _loc16_ = lineAlpha != null ? lineAlpha : 100;
         if(lineWidth != null && lineWidth != 0)
         {
            _loc15_ = true;
            clip.lineStyle(lineWidth,lineColor,_loc16_);
         }
         else
         {
            clip.lineStyle(0,0,0);
         }
         clip.moveTo(x,y);
         _loc21_ = Math.ceil(Math.abs(arc) / 45);
         _loc17_ = arc / _loc21_;
         _loc18_ = (- _loc17_ / 180) * Math.PI;
         _loc19_ = (- startAngle / 180) * Math.PI;
         if(_loc21_ > 0)
         {
            _loc22_ = x + Math.cos(startAngle / 180 * Math.PI) * xRadius;
            _loc23_ = y + Math.sin((- startAngle) / 180 * Math.PI) * yRadius;
            clip.lineTo(_loc22_,_loc23_);
            _loc28_ = 0;
            while(_loc28_ < _loc21_)
            {
               _loc19_ += _loc18_;
               _loc20_ = _loc19_ - _loc18_ / 2;
               _loc24_ = x + Math.cos(_loc19_) * xRadius;
               _loc25_ = y + Math.sin(_loc19_) * yRadius;
               _loc26_ = x + Math.cos(_loc20_) * (xRadius / Math.cos(_loc18_ / 2));
               _loc27_ = y + Math.sin(_loc20_) * (yRadius / Math.cos(_loc18_ / 2));
               clip.curveTo(_loc26_,_loc27_,_loc24_,_loc25_);
               _loc28_ = _loc28_ + 1;
            }
            clip.lineTo(x,y);
         }
         if(color != null)
         {
            clip.endFill();
         }
      }
   }
}
