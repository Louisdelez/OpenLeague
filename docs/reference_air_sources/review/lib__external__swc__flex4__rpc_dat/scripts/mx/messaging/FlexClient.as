package mx.messaging
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [Event(name="propertyChange",type="mx.events.PropertyChangeEvent")]
   public class FlexClient extends EventDispatcher
   {
      
      private static var _instance:FlexClient;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const NULL_FLEXCLIENT_ID:String = "nil";
      
      private var _id:String;
      
      private var _waitForFlexClientId:Boolean = false;
      
      public function FlexClient()
      {
         super();
      }
      
      public static function getInstance() : FlexClient
      {
         if(_instance == null)
         {
            _instance = new FlexClient();
         }
         return _instance;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(value:String) : void
      {
         var event:PropertyChangeEvent = null;
         if(this._id != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"id",this._id,value);
            this._id = value;
            dispatchEvent(event);
         }
      }
      
      [Bindable(event="propertyChange")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get waitForFlexClientId() : Boolean
      {
         return this._waitForFlexClientId;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set waitForFlexClientId(value:Boolean) : void
      {
         var event:PropertyChangeEvent = null;
         if(this._waitForFlexClientId != value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"waitForFlexClientId",this._waitForFlexClientId,value);
            this._waitForFlexClientId = value;
            dispatchEvent(event);
         }
      }
   }
}

