package blix.i18n
{
   import blix.action.MultiAction;
   import blix.util.string.strTrim;
   
   public class LocaleChainLoaderAction extends MultiAction
   {
      
      public var isText:Boolean;
      
      public var localizer:ILocalizationManager;
      
      public var urlWithTokens:String;
      
      public var localeChain:Vector.<String>;
      
      public function LocaleChainLoaderAction(param1:ILocalizationManager = null, param2:Vector.<String> = null, param3:String = null, param4:Boolean = true, param5:Boolean = false)
      {
         super(param5);
         this.localizer = param1;
         this.localeChain = param2;
         this.urlWithTokens = param3;
         this.isText = param4;
      }
      
      public static function parseLocaleChain(param1:String, param2:String = ",") : Vector.<String>
      {
         var _loc5_:String = null;
         if(!param1)
         {
            return null;
         }
         var _loc3_:Array = param1.split(param2);
         var _loc4_:Vector.<String> = new Vector.<String>();
         for each(_loc5_ in _loc3_)
         {
            _loc5_ = strTrim(_loc5_);
            if(_loc4_.indexOf(_loc5_) == -1)
            {
               _loc4_[_loc4_.length] = _loc5_;
            }
         }
         return _loc4_;
      }
      
      override public function invoke() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this.localeChain)
         {
            addAction(new LocaleLoaderAction(this.localizer,_loc1_,this.urlWithTokens,this.isText,true));
         }
         super.invoke();
      }
   }
}

