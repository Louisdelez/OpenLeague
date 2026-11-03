package com.riotgames.pvpnet.fatal
{
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.NativeWindowSystemChrome;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FatalErrorWindow extends NativeWindow
   {
      
      public function FatalErrorWindow(param1:String)
      {
         var _loc2_:NativeWindowInitOptions = new NativeWindowInitOptions();
         _loc2_.maximizable = false;
         _loc2_.minimizable = false;
         _loc2_.systemChrome = NativeWindowSystemChrome.STANDARD;
         _loc2_.resizable = false;
         super(_loc2_);
         this.width = 600;
         this.height = 400;
         this.title = "PvP.net FATAL ERROR";
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         this.setBackgroundColor();
         this.showBackground();
         this.showError(param1);
      }
      
      private function showBackground() : void
      {
         var _loc1_:Loader = new Loader();
         _loc1_.load(new URLRequest("assets/images/champions/Amumu_Splash_0.jpg"));
         _loc1_.scaleX = 0.6667;
         _loc1_.scaleY = 0.6667;
         _loc1_.x = -10;
         _loc1_.y = -60;
         _loc1_.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,-20,-20,-20,0);
         _loc1_.filters = [new BlurFilter(2,2,BitmapFilterQuality.HIGH)];
         stage.addChild(_loc1_);
      }
      
      private function setBackgroundColor() : void
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(3355443);
         _loc2_.lineStyle();
         _loc2_.drawRect(0,0,600,400);
         _loc2_.endFill();
         stage.addChild(_loc1_);
      }
      
      private function showError(param1:String) : void
      {
         var _loc2_:TextField = new TextField();
         _loc2_.x = 30;
         _loc2_.y = 30;
         _loc2_.width = 320;
         _loc2_.height = 360;
         _loc2_.selectable = true;
         _loc2_.multiline = true;
         _loc2_.wordWrap = true;
         var _loc3_:TextFormat = new TextFormat(null,20,16777215);
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.setTextFormat(_loc3_);
         _loc2_.text = param1;
         stage.addChild(_loc2_);
      }
   }
}

