package flash.events
{
   import flash.display.InteractiveObject;
   import flash.utils.*;
   
   [native(cls="TouchEventClass",instance="TouchEventObject",methods="auto")]
   [Version("10.1")]
   public class TouchEvent extends Event
   {
      
      public static const TOUCH_BEGIN:String = "touchBegin";
      
      public static const TOUCH_END:String = "touchEnd";
      
      public static const TOUCH_MOVE:String = "touchMove";
      
      public static const TOUCH_OVER:String = "touchOver";
      
      public static const TOUCH_OUT:String = "touchOut";
      
      public static const TOUCH_ROLL_OVER:String = "touchRollOver";
      
      public static const TOUCH_ROLL_OUT:String = "touchRollOut";
      
      public static const TOUCH_TAP:String = "touchTap";
      
      public static const PROXIMITY_BEGIN:String = "proximityBegin";
      
      public static const PROXIMITY_END:String = "proximityEnd";
      
      public static const PROXIMITY_MOVE:String = "proximityMove";
      
      public static const PROXIMITY_OUT:String = "proximityOut";
      
      public static const PROXIMITY_OVER:String = "proximityOver";
      
      public static const PROXIMITY_ROLL_OUT:String = "proximityRollOut";
      
      public static const PROXIMITY_ROLL_OVER:String = "proximityRollOver";
      
      private var m_touchPointID:int;
      
      private var m_isPrimaryTouchPoint:Boolean;
      
      private var m_sizeY:Number;
      
      private var m_sizeX:Number;
      
      private var m_pressure:Number;
      
      private var m_relatedObject:InteractiveObject;
      
      private var m_isRelatedObjectInaccessible:Boolean;
      
      private var m_ctrlKey:Boolean;
      
      private var m_altKey:Boolean;
      
      private var m_shiftKey:Boolean;
      
      private var m_commandKey:Boolean;
      
      private var m_controlKey:Boolean;
      
      private var m_timestamp:Number;
      
      private var m_touchIntent:String;
      
      private var m_isTouchPointCanceled:Boolean;
      
      public function TouchEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, touchPointID:int = 0, isPrimaryTouchPoint:Boolean = false, localX:Number = NaN, localY:Number = NaN, sizeX:Number = NaN, sizeY:Number = NaN, pressure:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, commandKey:Boolean = false, controlKey:Boolean = false, timestamp:Number = NaN, touchIntent:String = "unknown", samples:ByteArray = null, isTouchPointCanceled:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.m_touchPointID = touchPointID;
         this.m_isPrimaryTouchPoint = isPrimaryTouchPoint;
         this.localX = localX;
         this.localY = localY;
         this.m_sizeX = sizeX;
         this.m_sizeY = sizeY;
         this.m_pressure = pressure;
         this.m_relatedObject = relatedObject;
         this.m_ctrlKey = ctrlKey;
         this.m_altKey = altKey;
         this.m_shiftKey = shiftKey;
         this.m_commandKey = commandKey;
         this.m_controlKey = controlKey;
         this.m_timestamp = timestamp;
         this.m_touchIntent = touchIntent;
         this.m_isTouchPointCanceled = isTouchPointCanceled;
         if(samples != null)
         {
            this.setSamples(samples);
         }
      }
      
      override public function clone() : Event
      {
         var tempSamples:ByteArray = null;
         tempSamples = new ByteArray();
         this.privateGetSamples(tempSamples);
         return new TouchEvent(type,bubbles,cancelable,this.m_touchPointID,this.m_isPrimaryTouchPoint,this.localX,this.localY,this.m_sizeX,this.m_sizeY,this.m_pressure,this.m_relatedObject,this.m_ctrlKey,this.m_altKey,this.m_shiftKey,this.m_commandKey,this.m_controlKey,this.m_timestamp,this.m_touchIntent,tempSamples,this.m_isTouchPointCanceled);
      }
      
      override public function toString() : String
      {
         return formatToString("TouchEvent","type","bubbles","cancelable","eventPhase","touchPointID","isPrimaryTouchPoint","localX","localY","stageX","stageY","sizeX","sizeY","pressure","relatedObject","ctrlKey","altKey","shiftKey","commandKey","controlKey","timestamp","touchIntent","isTouchPointCanceled");
      }
      
      public native function get localX() : Number;
      
      public native function set localX(param1:Number) : void;
      
      public native function get localY() : Number;
      
      public native function set localY(param1:Number) : void;
      
      public function get touchPointID() : int
      {
         return this.m_touchPointID;
      }
      
      public function set touchPointID(value:int) : void
      {
         this.m_touchPointID = value;
      }
      
      public function get isPrimaryTouchPoint() : Boolean
      {
         return this.m_isPrimaryTouchPoint;
      }
      
      public function set isPrimaryTouchPoint(value:Boolean) : void
      {
         this.m_isPrimaryTouchPoint = value;
      }
      
      public function get sizeX() : Number
      {
         return this.m_sizeX;
      }
      
      public function set sizeX(value:Number) : void
      {
         this.m_sizeX = value;
      }
      
      public function get sizeY() : Number
      {
         return this.m_sizeY;
      }
      
      public function set sizeY(value:Number) : void
      {
         this.m_sizeY = value;
      }
      
      public function get pressure() : Number
      {
         return this.m_pressure;
      }
      
      public function set pressure(value:Number) : void
      {
         this.m_pressure = value;
      }
      
      public function get relatedObject() : InteractiveObject
      {
         return this.m_relatedObject;
      }
      
      public function set relatedObject(value:InteractiveObject) : void
      {
         this.m_relatedObject = value;
      }
      
      public function get ctrlKey() : Boolean
      {
         return this.m_ctrlKey;
      }
      
      public function set ctrlKey(value:Boolean) : void
      {
         this.m_ctrlKey = value;
      }
      
      public function get altKey() : Boolean
      {
         return this.m_altKey;
      }
      
      public function set altKey(value:Boolean) : void
      {
         this.m_altKey = value;
      }
      
      public function get shiftKey() : Boolean
      {
         return this.m_shiftKey;
      }
      
      public function set shiftKey(value:Boolean) : void
      {
         this.m_shiftKey = value;
      }
      
      public function get stageX() : Number
      {
         if(Boolean(isNaN(this.localX)) || Boolean(isNaN(this.localY)))
         {
            return Number.NaN;
         }
         return this.getStageX();
      }
      
      public function get stageY() : Number
      {
         if(Boolean(isNaN(this.localX)) || Boolean(isNaN(this.localY)))
         {
            return Number.NaN;
         }
         return this.getStageY();
      }
      
      public native function updateAfterEvent() : void;
      
      private native function getStageX() : Number;
      
      private native function getStageY() : Number;
      
      public function get isRelatedObjectInaccessible() : Boolean
      {
         return this.m_isRelatedObjectInaccessible;
      }
      
      public function set isRelatedObjectInaccessible(value:Boolean) : void
      {
         this.m_isRelatedObjectInaccessible = value;
      }
      
      public function get commandKey() : Boolean
      {
         return this.m_commandKey;
      }
      
      public function set commandKey(value:Boolean) : void
      {
         this.m_commandKey = value;
      }
      
      public function get controlKey() : Boolean
      {
         return this.m_controlKey;
      }
      
      public function set controlKey(value:Boolean) : void
      {
         this.m_controlKey = value;
      }
      
      [API("675")]
      public native function isToolButtonDown(param1:int) : Boolean;
      
      [API("675")]
      public function get timestamp() : Number
      {
         return this.m_timestamp;
      }
      
      [API("675")]
      public function set timestamp(value:Number) : void
      {
         this.m_timestamp = value;
      }
      
      [API("675")]
      public function get touchIntent() : String
      {
         return this.m_touchIntent;
      }
      
      [API("675")]
      public function set touchIntent(value:String) : void
      {
         this.m_touchIntent = value;
      }
      
      [API("675")]
      public function get isTouchPointCanceled() : Boolean
      {
         return this.m_isTouchPointCanceled;
      }
      
      [API("675")]
      public function set isTouchPointCanceled(value:Boolean) : void
      {
         this.m_isTouchPointCanceled = value;
      }
      
      [API("675")]
      public native function getSamples(param1:ByteArray, param2:Boolean = false) : uint;
      
      private native function privateGetSamples(param1:ByteArray) : uint;
      
      private native function setSamples(param1:ByteArray) : void;
   }
}

