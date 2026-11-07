package blix.i18n
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import blix.action.LoaderAction;
   import blix.action.UrlLoaderAction;
   import blix.util.string.strReplace;
   import blix.util.string.strTrim;
   import flash.net.URLRequest;
   
   public class LocaleLoaderAction extends BasicAction
   {
      
      public var isText:Boolean;
      
      public var localizer:ILocalizationManager;
      
      public var locale:String;
      
      public var urlWithTokens:String;
      
      protected var urlLoaderAction:UrlLoaderAction;
      
      protected var loaderAction:LoaderAction;
      
      public function LocaleLoaderAction(param1:ILocalizationManager, param2:String, param3:String, param4:Boolean = true, param5:Boolean = false)
      {
         super(param5);
         var _loc6_:String = strReplace(param3,"{locale}",param2);
         if(param4)
         {
            this.urlLoaderAction = new UrlLoaderAction(new URLRequest(_loc6_),null,param5);
            this.urlLoaderAction.getCompleted().add(this.completedHandler);
            this.urlLoaderAction.getErred().add(this.loaderActionErredHandler);
         }
         else
         {
            this.loaderAction = new LoaderAction(new URLRequest(_loc6_),null,param5);
            this.loaderAction.getCompleted().add(this.completedHandler);
            this.loaderAction.getErred().add(this.loaderActionErredHandler);
         }
         this.localizer = param1;
         this.locale = param2;
         this.urlWithTokens = param3;
         this.isText = param4;
      }
      
      private function loaderActionErredHandler(param1:IAction) : void
      {
         err(param1.getError());
      }
      
      protected function completedHandler() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(this.isText)
         {
            _loc1_ = this.urlLoaderAction.data;
         }
         else
         {
            if(this.loaderAction.loader.content.hasOwnProperty("create"))
            {
               _loc4_ = Object(this.loaderAction.loader.content).create();
               if(1 == 1)
               {
                  _loc1_ = "";
               }
            }
            if(!this.loaderAction.loader.content.hasOwnProperty("propertiesClass"))
            {
               err(new Error("Locale bundle did not have \'propertiesClass\' property."));
               return;
            }
            _loc3_ = Object(this.loaderAction.loader.content).propertiesClass;
            _loc1_ = new _loc3_();
         }
         if(!_loc1_)
         {
            err(new Error("Locale content was invalid or empty."));
         }
         for each(_loc2_ in _loc1_.split("\n"))
         {
            _loc5_ = _loc2_.indexOf("=");
            if(_loc5_ != -1)
            {
               _loc6_ = strTrim(_loc2_.substring(0,_loc5_));
               _loc7_ = strTrim(_loc2_.substr(_loc5_ + 1));
               if(_loc6_)
               {
                  this.localizer.setText(_loc6_,this.locale,_loc7_);
               }
            }
         }
         complete();
      }
      
      override protected function doInvocation() : void
      {
         if(this.isText)
         {
            this.urlLoaderAction.invoke();
         }
         else
         {
            this.loaderAction.invoke();
         }
      }
      
      override public function abort() : void
      {
         if(this.isText)
         {
            this.urlLoaderAction.abort();
         }
         else
         {
            this.loaderAction.abort();
         }
         super.abort();
      }
      
      override public function reset() : void
      {
         if(this.isText)
         {
            this.urlLoaderAction.reset();
         }
         else
         {
            this.loaderAction.reset();
         }
         super.reset();
      }
   }
}

