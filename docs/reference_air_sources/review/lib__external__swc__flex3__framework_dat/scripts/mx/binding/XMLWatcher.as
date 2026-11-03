package mx.binding
{
   import mx.core.mx_internal;
   import mx.utils.IXMLNotifiable;
   import mx.utils.XMLNotifier;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class XMLWatcher extends Watcher implements IXMLNotifiable
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var parentObj:Object;
      
      private var _propertyName:String;
      
      public function XMLWatcher(propertyName:String, listeners:Array)
      {
         super(listeners);
         _propertyName = propertyName;
      }
      
      public function get propertyName() : String
      {
         return _propertyName;
      }
      
      public function xmlNotification(currentTarget:Object, type:String, target:Object, value:Object, detail:Object) : void
      {
         updateProperty();
         notifyListeners(true);
      }
      
      override public function updateParent(parent:Object) : void
      {
         if(Boolean(parentObj) && (parentObj is XML || parentObj is XMLList))
         {
            XMLNotifier.getInstance().unwatchXML(parentObj,this);
         }
         if(parent is Watcher)
         {
            parentObj = parent.value;
         }
         else
         {
            parentObj = parent;
         }
         if(Boolean(parentObj) && (parentObj is XML || parentObj is XMLList))
         {
            XMLNotifier.getInstance().watchXML(parentObj,this);
         }
         wrapUpdate(updateProperty);
      }
      
      private function updateProperty() : void
      {
         if(Boolean(parentObj))
         {
            if(_propertyName == "this")
            {
               value = parentObj;
            }
            else
            {
               value = parentObj[_propertyName];
            }
         }
         else
         {
            value = null;
         }
         updateChildren();
      }
      
      override protected function shallowClone() : Watcher
      {
         return new XMLWatcher(_propertyName,listeners);
      }
   }
}

