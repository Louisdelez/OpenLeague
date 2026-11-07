package mx.binding
{
   import mx.core.mx_internal;
   import mx.utils.IXMLNotifiable;
   import mx.utils.XMLNotifier;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class XMLWatcher extends Watcher implements IXMLNotifiable
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var parentObj:Object;
      
      private var _propertyName:String;
      
      public function XMLWatcher(propertyName:String, listeners:Array)
      {
         super(listeners);
         this._propertyName = propertyName;
      }
      
      public function get propertyName() : String
      {
         return this._propertyName;
      }
      
      override public function updateParent(parent:Object) : void
      {
         if(Boolean(this.parentObj) && (this.parentObj is XML || this.parentObj is XMLList))
         {
            XMLNotifier.getInstance().unwatchXML(this.parentObj,this);
         }
         if(parent is Watcher)
         {
            this.parentObj = parent.value;
         }
         else
         {
            this.parentObj = parent;
         }
         if(Boolean(this.parentObj) && (this.parentObj is XML || this.parentObj is XMLList))
         {
            XMLNotifier.getInstance().watchXML(this.parentObj,this);
         }
         wrapUpdate(this.updateProperty);
      }
      
      override protected function shallowClone() : Watcher
      {
         return new XMLWatcher(this._propertyName,listeners);
      }
      
      private function updateProperty() : void
      {
         if(Boolean(this.parentObj))
         {
            if(this._propertyName == "this")
            {
               value = this.parentObj;
            }
            else
            {
               value = this.parentObj[this._propertyName];
            }
         }
         else
         {
            value = null;
         }
         updateChildren();
      }
      
      public function xmlNotification(currentTarget:Object, type:String, target:Object, value:Object, detail:Object) : void
      {
         this.updateProperty();
         notifyListeners(true);
      }
   }
}

