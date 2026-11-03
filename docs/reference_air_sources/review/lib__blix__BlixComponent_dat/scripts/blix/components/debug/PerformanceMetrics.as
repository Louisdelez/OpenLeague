package blix.components.debug
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import blix.frame.getEnterFrame;
   import blix.util.string.format.bytesToStr;
   import flash.display.Sprite;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class PerformanceMetrics extends SpriteProxy
   {
      
      private var textField:TextFieldProxy;
      
      private var refreshIntervalId:uint;
      
      private var frames:uint;
      
      private var refreshDelay:Number;
      
      public function PerformanceMetrics(param1:IContext, param2:Number = 3000)
      {
         var parentContext:IContext = param1;
         var refreshDelay:Number = param2;
         super(parentContext,new Sprite());
         this.refreshDelay = refreshDelay;
         if(refreshDelay > 0)
         {
            this.refreshIntervalId = setInterval(this.refresh,refreshDelay);
         }
         this.refresh();
         getEnterFrame().add(function():void
         {
            ++frames;
         });
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.textField = new TextFieldProxy(this,new TextField());
         this.textField.setBackground(true);
         this.textField.setBackgroundColor(0);
         this.textField.setAutoSize(TextFieldAutoSize.LEFT);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.color = 16777215;
         _loc1_.size = 14;
         this.textField.setDefaultTextFormat(_loc1_);
         addChild(this.textField);
      }
      
      public function refresh() : void
      {
         this.textField.setText(bytesToStr(System.totalMemory));
         var _loc1_:String = (this.frames / this.refreshDelay * 1000).toFixed(0);
         if(this.frames > 0)
         {
            this.textField.appendText(" " + _loc1_ + " FPS");
            this.frames = 0;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         clearInterval(this.refreshIntervalId);
      }
   }
}

