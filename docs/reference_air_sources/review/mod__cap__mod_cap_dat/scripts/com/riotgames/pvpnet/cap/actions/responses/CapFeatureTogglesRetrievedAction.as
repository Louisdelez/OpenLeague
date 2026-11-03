package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapFeatureTogglesRetrievedAction extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "featureTogglesRetrieved";
      
      private static const ENABLED_FEATURES_KEY:String = "enabledFeatures";
      
      private var _model:CapModel;
      
      public function CapFeatureTogglesRetrievedAction(param1:CapModel, param2:IDecode, param3:String = null)
      {
         this._model = param1;
         super(METHOD_NAME,param2,param3);
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc2_:Object = {};
         if(param1[ENABLED_FEATURES_KEY])
         {
            _loc3_ = param1[ENABLED_FEATURES_KEY];
            while(_loc3_.length)
            {
               _loc2_[_loc3_.shift()] = true;
            }
         }
         this._model.enabledFeatureToggles = _loc2_;
      }
   }
}

