package
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.utils.Lib;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.core.IUIComponent;
   
   [Event(name="championSelectOver",type="flash.events.Event")]
   [Event(name="tradeButtonOut",type="flash.events.Event")]
   [Event(name="tradeButtonOver",type="flash.events.Event")]
   [Event(name="tradeButtonClicked",type="flash.events.Event")]
   [Embed(source="/_assets/assets.swf", symbol="symbol167")]
   public dynamic class ChampionSelect extends MyUIMovieClip
   {
      
      public static const CHAMPION_SELECT_STATE_INACTIVESELF:String = "inactiveSelf";
      
      public static const CHAMPION_SELECT_STATE_INACTIVEOTHER:String = "inactiveOther";
      
      public static const CHAMPION_SELECT_STATE_ACTIVESELF:String = "activeSelf";
      
      public static const CHAMPION_SELECT_STATE_ACTIVEOTHER:String = "activeOther";
      
      public var scaleRatio:Number;
      
      public var bg_mc:MovieClip;
      
      public var compBG_mc:MovieClip;
      
      public var boundingBox:MovieClip;
      
      public var slotName_mc:TextFieldMovieClip;
      
      public var slotRating_mc:TextFieldMovieClip;
      
      private var _slotName:String;
      
      private var _slotRating:String;
      
      private var _isDebug:Boolean = true;
      
      private var _animateFlag:Boolean = true;
      
      public var _active:Boolean;
      
      public var _tradeButtonVisible:Boolean;
      
      private var _currentState:String;
      
      public var frameLabelArr:Array = ["inactiveSelf","inactiveOther","activeSelf","activeOther"];
      
      public var cs_slotItem0:SlotItem;
      
      public var isOverTradePanel:Boolean;
      
      public function ChampionSelect()
      {
         addFrameScript(0,this.frame1);
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(evt:Event) : void
      {
         this.init();
      }
      
      public function init() : void
      {
         Lib.output("init");
         this.gotoState(CHAMPION_SELECT_STATE_INACTIVEOTHER);
         this.addListeners();
      }
      
      public function addListeners() : void
      {
      }
      
      public function gotoStateIndex(idx:uint) : void
      {
         this.currentState = this.frameLabelArr[idx];
      }
      
      public function setSlotItem(compIdx:uint, champImg:IUIComponent, img0:IUIComponent, img1:IUIComponent) : void
      {
         var compName:String = "cs_slotItem" + compIdx;
         this[compName].setSlotItem(champImg,img0,img1);
      }
      
      public function setText(slotRating:String, slotName:String) : void
      {
         this.slotRating_mc.labelName = slotRating;
         this.slotName_mc.labelName = slotName;
      }
      
      private function onTradeButtonOver(evt:MouseEvent) : void
      {
         Lib.output("tradeButtonOver:");
         this.dispatchEvent(new Event("tradeButtonOver"));
      }
      
      private function onTradeButtonOut(evt:MouseEvent) : void
      {
         Lib.output("tradeButtonOut:");
         this.dispatchEvent(new Event("tradeButtonOut"));
      }
      
      private function onTradeButtonClicked(evt:MouseEvent) : void
      {
         Lib.output("tradeButtonClicked:");
         this.dispatchEvent(new Event("tradeButtonClicked"));
      }
      
      public function set championImg(value:IUIComponent) : void
      {
         this.cs_slotItem0.setComp(this.cs_slotItem0.championImg,value);
      }
      
      public function set spellImg0(value:IUIComponent) : void
      {
         this.cs_slotItem0.setComp(this.cs_slotItem0.spellImg0,value);
      }
      
      public function set spellImg1(value:IUIComponent) : void
      {
         this.cs_slotItem0.setComp(this.cs_slotItem0.spellImg1,value);
      }
      
      public function set slotName(value:String) : void
      {
         this._slotName = value;
         this.slotName_mc.labelName = value;
      }
      
      public function get slotName() : String
      {
         return this._slotName;
      }
      
      public function set slotRating(value:String) : void
      {
         this._slotRating = value;
         this.slotRating_mc.labelName = value;
      }
      
      public function get slotRating() : String
      {
         return this._slotRating;
      }
      
      public function set active(isTrue:Boolean) : void
      {
         this._active = isTrue;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set animateFlag(value:Boolean) : void
      {
         this._animateFlag = value;
      }
      
      public function get animateFlag() : Boolean
      {
         return this._animateFlag;
      }
      
      override public function set currentState(value:String) : void
      {
         this.cs_slotItem0.currentState = value;
         this.gotoState(value,this._animateFlag);
      }
      
      public function gotoState(value:String, shouldAnimate:Boolean = false) : void
      {
         var targetScaleVal:Number = NaN;
         switch(value)
         {
            case CHAMPION_SELECT_STATE_INACTIVESELF:
               this.fadeMovie(this.bg_mc.orange_animation,0,shouldAnimate ? 0.2 : 0);
               this.fadeMovie(this.bg_mc.blue_animation,1,shouldAnimate ? 1 : 0);
               this.removeGlowTween();
               targetScaleVal = 1;
               this.bg_mc.orange_animation.gotoAndStop("static");
               TweenLite.from(this,shouldAnimate ? 0.6 : 0,{
                  "scaleX":1.1,
                  "scaleY":1.1,
                  "alpha":1,
                  "ease":Bounce.easeOut
               });
               break;
            case CHAMPION_SELECT_STATE_INACTIVEOTHER:
               this.fadeMovie(this.bg_mc.orange_animation,0,shouldAnimate ? 0.2 : 0);
               this.fadeMovie(this.bg_mc.blue_animation,0,shouldAnimate ? 0.2 : 0);
               this.removeGlowTween();
               targetScaleVal = 1;
               break;
            case CHAMPION_SELECT_STATE_ACTIVESELF:
               this.fadeMovie(this.bg_mc.blue_animation,0,shouldAnimate ? 0.2 : 0);
               this.fadeMovie(this.bg_mc.orange_animation,1,shouldAnimate ? 1 : 0);
               this.bg_mc.orange_animation.gotoAndPlay("loop");
               TweenMax.to(this.bg_mc,shouldAnimate ? 0.5 : 0,{"colorMatrixFilter":{
                  "colorize":16777215,
                  "amount":0.6,
                  "brightness":3
               }});
               TweenMax.delayedCall(0.3,this.removeGlowTween);
               targetScaleVal = 1;
               break;
            case CHAMPION_SELECT_STATE_ACTIVEOTHER:
               this.fadeMovie(this.bg_mc.blue_animation,0,shouldAnimate ? 1 : 0);
               this.fadeMovie(this.bg_mc.orange_animation,0,shouldAnimate ? 1 : 0);
               TweenMax.to(this.bg_mc,shouldAnimate ? 0.5 : 0,{"colorMatrixFilter":{
                  "colorize":16777215,
                  "amount":0.6,
                  "brightness":3
               }});
               TweenMax.delayedCall(0.3,this.decreaseGlow);
               targetScaleVal = 1;
         }
         if(this.scaleRatio != targetScaleVal)
         {
            this.scaleMovie(this,targetScaleVal,shouldAnimate ? 0.6 : 0);
         }
      }
      
      public function removeGlowTween() : void
      {
         TweenMax.to(this.bg_mc,0.5,{"colorMatrixFilter":{}});
      }
      
      public function decreaseGlow() : void
      {
         TweenMax.to(this.bg_mc,0.5,{"colorMatrixFilter":{
            "colorize":16777215,
            "amount":1,
            "brightness":1.35
         }});
      }
      
      public function hideMovie(mc:MovieClip, isTrue:Boolean) : void
      {
         if(isTrue)
         {
            mc.alpha = 0;
            mc.visible = false;
         }
         else
         {
            mc.alpha = 1;
            mc.visible = true;
         }
      }
      
      public function fadeMovie(mc:MovieClip, targetValue:Number, duration:Number) : void
      {
         TweenMax.to(mc,duration,{"autoAlpha":targetValue});
      }
      
      public function scaleMovie(mc:MovieClip, targetValue:Number, duration:Number) : void
      {
         TweenLite.to(mc,duration,{
            "scaleX":targetValue,
            "scaleY":targetValue,
            "alpha":1,
            "ease":Elastic.easeOut
         });
         this.scaleRatio = targetValue;
      }
      
      override public function get measuredWidth() : Number
      {
         return this.boundingBox.width;
      }
      
      override public function get measuredHeight() : Number
      {
         return this.boundingBox.width;
      }
      
      override public function setActualSize(newWidth:Number, newHeight:Number) : void
      {
         if(newWidth != _width || newHeight != _height)
         {
            _width = newWidth;
            _height = newHeight;
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}

