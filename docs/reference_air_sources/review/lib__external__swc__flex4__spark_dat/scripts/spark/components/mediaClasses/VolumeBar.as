package spark.components.mediaClasses
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.geom.Point;
   import mx.events.FlexEvent;
   import mx.managers.LayoutManager;
   import spark.components.VSlider;
   import spark.components.supportClasses.DropDownController;
   import spark.events.DropDownEvent;
   
   [SkinState("open")]
   [Style(name="rollOverOpenDelay",type="Number",inherit="no")]
   [Event(name="mutedChange",type="mx.events.FlexEvent")]
   [Event(name="open",type="spark.events.DropDownEvent")]
   [Event(name="close",type="spark.events.DropDownEvent")]
   public class VolumeBar extends VSlider
   {
      
      private static var _skinParts:Object = {
         "dataTip":false,
         "track":false,
         "thumb":false,
         "dropDown":false,
         "muteButton":false
      };
      
      [SkinPart(required="false")]
      public var muteButton:MuteButton;
      
      [SkinPart(required="false")]
      public var dropDown:DisplayObject;
      
      private var _dropDownController:DropDownController;
      
      private var _muted:Boolean = false;
      
      public function VolumeBar()
      {
         super();
         this.dropDownController = new DropDownController();
         addEventListener(Event.CHANGE,this.changeHandler);
      }
      
      protected function get dropDownController() : DropDownController
      {
         return this._dropDownController;
      }
      
      protected function set dropDownController(value:DropDownController) : void
      {
         if(this._dropDownController == value)
         {
            return;
         }
         this._dropDownController = value;
         this._dropDownController.addEventListener(DropDownEvent.OPEN,this.dropDownController_openHandler);
         this._dropDownController.addEventListener(DropDownEvent.CLOSE,this.dropDownController_closeHandler);
         this._dropDownController.rollOverOpenDelay = getStyle("rollOverOpenDelay");
         if(Boolean(this.muteButton))
         {
            this._dropDownController.openButton = this.muteButton;
         }
         if(Boolean(this.dropDown))
         {
            this._dropDownController.dropDown = this.dropDown;
         }
      }
      
      public function get isDropDownOpen() : Boolean
      {
         if(Boolean(this.dropDownController))
         {
            return this.dropDownController.isOpen;
         }
         return false;
      }
      
      [Bindable("mutedChange")]
      public function get muted() : Boolean
      {
         return this._muted;
      }
      
      public function set muted(value:Boolean) : void
      {
         if(this._muted == value)
         {
            return;
         }
         this._muted = value;
         invalidateDisplayList();
         if(Boolean(this.muteButton))
         {
            this.muteButton.muted = value;
         }
         dispatchEvent(new FlexEvent(FlexEvent.MUTED_CHANGE));
      }
      
      override public function get baselinePosition() : Number
      {
         return getBaselinePositionForPart(this.muteButton);
      }
      
      override protected function updateSkinDisplayList() : void
      {
         var thumbPosTrackY:Number = NaN;
         if(!thumb || !track)
         {
            return;
         }
         var thumbRange:Number = track.getLayoutBoundsHeight() - thumb.getLayoutBoundsHeight();
         var range:Number = maximum - minimum;
         if(!this.muted)
         {
            thumbPosTrackY = range > 0 ? thumbRange - (pendingValue - minimum) / range * thumbRange : 0;
         }
         else
         {
            thumbPosTrackY = thumbRange;
         }
         var thumbPos:Point = track.localToGlobal(new Point(0,thumbPosTrackY));
         var thumbPosParentY:Number = Number(thumb.parent.globalToLocal(thumbPos).y);
         thumb.setLayoutBoundsPosition(thumb.getLayoutBoundsX(),Math.round(thumbPosParentY));
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         var allStyles:Boolean = styleProp == null || styleProp == "styleName";
         if(allStyles || styleProp == "rollOverOpenDelay")
         {
            if(Boolean(this.dropDownController))
            {
               this.dropDownController.rollOverOpenDelay = getStyle("rollOverOpenDelay");
            }
         }
      }
      
      override protected function setValue(value:Number) : void
      {
         super.setValue(value);
         if(Boolean(this.muteButton))
         {
            this.muteButton.volume = value;
         }
      }
      
      override protected function getCurrentSkinState() : String
      {
         return !enabled ? "disabled" : (this.dropDownController.isOpen ? "open" : "normal");
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.muteButton)
         {
            if(Boolean(this.dropDownController))
            {
               this.dropDownController.openButton = this.muteButton;
            }
            this.muteButton.addEventListener(FlexEvent.MUTED_CHANGE,this.muteButton_mutedChangeHandler);
            this.muteButton.volume = value;
            this.muteButton.muted = this.muted;
         }
         else if(instance == this.dropDown && Boolean(this.dropDownController))
         {
            this.dropDownController.dropDown = this.dropDown;
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         if(instance == this.muteButton)
         {
            this.muteButton.removeEventListener(FlexEvent.MUTED_CHANGE,this.muteButton_mutedChangeHandler);
         }
         else if(instance == this.dropDownController)
         {
            if(instance == this.muteButton)
            {
               this.dropDownController.openButton = null;
            }
            if(instance == this.dropDown)
            {
               this.dropDownController.dropDown = null;
            }
         }
         super.partRemoved(partName,instance);
      }
      
      override public function setFocus() : void
      {
         this.openDropDown();
         LayoutManager.getInstance().validateNow();
         super.setFocus();
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         this.dropDownController.processFocusOut(event);
         super.focusOutHandler(event);
      }
      
      public function openDropDown() : void
      {
         this.dropDownController.openDropDown();
      }
      
      public function closeDropDown(commit:Boolean) : void
      {
         this.dropDownController.closeDropDown(commit);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dropDownController_openHandler(event:DropDownEvent) : void
      {
         invalidateSkinState();
         dispatchEvent(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dropDownController_closeHandler(event:DropDownEvent) : void
      {
         invalidateSkinState();
         dispatchEvent(event);
      }
      
      private function changeHandler(event:Event) : void
      {
         if(this.muted)
         {
            this.muted = false;
         }
      }
      
      private function muteButton_mutedChangeHandler(event:FlexEvent) : void
      {
         this.muted = this.muteButton.muted;
      }
   }
}

