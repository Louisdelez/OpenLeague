package com.riotgames.pvpnet.docked.chat.view.taskbar
{
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.ILayoutAlgorithm;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutElement;
   import com.riotgames.pvpnet.chat.IDockedMessageWindow;
   import flash.geom.Rectangle;
   
   public class DockedChatLayout implements ILayoutAlgorithm
   {
      
      public var gapBetweenWindows:Number = 3;
      
      public var maxChatWindowSize:Number = 173;
      
      private var _layoutInvalidated:Signal = new Signal();
      
      public function DockedChatLayout()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function getSizeConstraints(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : SizeConstraints
      {
         return new SizeConstraints(new MinMax(param1),new MinMax(param2));
      }
      
      public function updateLayout(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : Rectangle
      {
         var _loc8_:LayoutEntry = null;
         var _loc9_:ILayoutElement = null;
         var _loc10_:IDockedMessageWindow = null;
         var _loc4_:Number = (this.maxChatWindowSize + this.gapBetweenWindows) * param3.length;
         var _loc5_:Number = param1 / param3.length - this.gapBetweenWindows;
         var _loc6_:Number = _loc4_ > param1 ? _loc5_ : this.maxChatWindowSize;
         var _loc7_:Number = 0;
         for each(_loc8_ in param3)
         {
            _loc9_ = _loc8_.element;
            if(_loc9_ is IDockedMessageWindow)
            {
               _loc10_ = _loc9_ as IDockedMessageWindow;
               _loc10_.setAvailableSpace(new Rectangle(0,0,param1,0));
            }
            _loc9_.setExplicitSize(_loc6_,NaN);
            _loc9_.setExplicitPosition(_loc7_,NaN);
            _loc7_ += _loc6_ + this.gapBetweenWindows;
         }
         return new Rectangle(0,0,param1,param2);
      }
   }
}

