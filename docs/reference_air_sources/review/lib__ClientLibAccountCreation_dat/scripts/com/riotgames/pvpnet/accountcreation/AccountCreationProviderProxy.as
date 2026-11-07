package com.riotgames.pvpnet.accountcreation
{
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import com.riotgames.pvpnet.accountcreation.model.ChooseIconModel;
   import com.riotgames.pvpnet.accountcreation.model.EloQuestionnaireModel;
   import com.riotgames.pvpnet.accountcreation.model.PlayTutorialModel;
   import com.riotgames.pvpnet.accountcreation.model.SummonerNameModel;
   
   public class AccountCreationProviderProxy extends ProviderProxyBase implements IAccountCreationProvider
   {
      
      private static var _instance:IAccountCreationProvider;
      
      public function AccountCreationProviderProxy()
      {
         super(IAccountCreationProvider);
      }
      
      public static function get instance() : IAccountCreationProvider
      {
         if(_instance == null)
         {
            _instance = new AccountCreationProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IAccountCreationProvider) : void
      {
         _instance = param1;
         ProviderLookup.setProviderProxy(IAccountCreationProvider,param1);
      }
      
      public function getEloQuestionnaireModel() : EloQuestionnaireModel
      {
         return _invoke("getEloQuestionnaireModel") as EloQuestionnaireModel;
      }
      
      public function getPlayTutorialModel() : PlayTutorialModel
      {
         return _invoke("getPlayTutorialModel") as PlayTutorialModel;
      }
      
      public function getSummonerNameModel() : SummonerNameModel
      {
         return _invoke("getSummonerNameModel") as SummonerNameModel;
      }
      
      public function getChooseIconModel() : ChooseIconModel
      {
         return _invoke("getChooseIconModel") as ChooseIconModel;
      }
      
      public function requestLoadIcons() : void
      {
         _invoke("requestLoadIcons");
      }
      
      public function handleStoreIconFulfillment(param1:int, param2:Boolean) : void
      {
         _invoke("handleStoreIconFulfillment",[param1,param2]);
      }
   }
}

