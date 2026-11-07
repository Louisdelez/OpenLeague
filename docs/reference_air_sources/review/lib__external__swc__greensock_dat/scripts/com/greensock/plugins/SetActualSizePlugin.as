package com.greensock.plugins
{
   import com.greensock.*;
   
   public class SetActualSizePlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _setWidth:Boolean;
      
      public var width:Number;
      
      public var height:Number;
      
      protected var _hasSetSize:Boolean;
      
      protected var _setHeight:Boolean;
      
      protected var _target:Object;
      
      public function SetActualSizePlugin()
      {
         super();
         this.propName = "setActualSize";
         this.overwriteProps = ["setActualSize","setSize","width","height","scaleX","scaleY"];
         this.round = true;
      }
      
      override public function killProps(lookup:Object) : void
      {
         super.killProps(lookup);
         if(_tweens.length == 0 || "setActualSize" in lookup)
         {
            this.overwriteProps = [];
         }
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         _target = target;
         _hasSetSize = Boolean("setActualSize" in _target);
         if("width" in value && _target.width != value.width)
         {
            addTween(_hasSetSize ? this : _target,"width",_target.width,value.width,"width");
            _setWidth = _hasSetSize;
         }
         if("height" in value && _target.height != value.height)
         {
            addTween(_hasSetSize ? this : _target,"height",_target.height,value.height,"height");
            _setHeight = _hasSetSize;
         }
         if(_tweens.length == 0)
         {
            _hasSetSize = false;
         }
         return true;
      }
      
      override public function set changeFactor(n:Number) : void
      {
         updateTweens(n);
         if(_hasSetSize)
         {
            _target.setActualSize(_setWidth ? this.width : _target.width,_setHeight ? this.height : _target.height);
         }
      }
   }
}

