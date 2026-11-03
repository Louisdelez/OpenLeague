package blix.action
{
   import flash.events.Event;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class XmlLoaderAction extends UrlLoaderAction
   {
      
      public var xml:XML;
      
      public function XmlLoaderAction(param1:URLRequest = null, param2:Boolean = false)
      {
         super(param1,URLLoaderDataFormat.TEXT,param2);
      }
      
      override protected function completedHandler(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
            data = this.xml = new XML(_urlLoader.data);
         }
         catch(error:Error)
         {
            err(error);
            return;
         }
         if(unmarshallDataFunction != null)
         {
            try
            {
               unmarshalledData = unmarshallDataFunction(this.xml);
            }
            catch(error:Error)
            {
               err(error);
               return;
            }
         }
         complete();
      }
   }
}

