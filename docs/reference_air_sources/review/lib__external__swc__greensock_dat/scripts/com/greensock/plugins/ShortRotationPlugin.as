package com.greensock.plugins
{
   import com.greensock.*;
   
   public class ShortRotationPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      public function ShortRotationPlugin()
      {
         super();
         this.propName = "shortRotation";
         this.overwriteProps = [];
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         var p:String = null;
         if(typeof value == "number")
         {
            return false;
         }
         var useRadians:Boolean = Boolean(value.useRadians == true);
         for(p in value)
         {
            if(p != "useRadians")
            {
               initRotation(target,p,target[p],typeof value[p] == "number" ? Number(value[p]) : target[p] + Number(value[p]),useRadians);
            }
         }
         return true;
      }
      
      public function initRotation(target:Object, propName:String, start:Number, end:Number, useRadians:Boolean = false) : void
      {
         var cap:Number = useRadians ? Math.PI * 2 : 360;
         var dif:Number = (end - start) % cap;
         if(dif != dif % (cap / 2))
         {
            dif = dif < 0 ? dif + cap : dif - cap;
         }
         addTween(target,propName,start,start + dif,propName);
         this.overwriteProps[this.overwriteProps.length] = propName;
      }
   }
}

