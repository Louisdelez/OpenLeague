package com.riotgames.pvpnet.accountcreation
{
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.accountcreation.model.ChooseIconModel;
   import com.riotgames.pvpnet.accountcreation.model.EloQuestionnaireModel;
   import com.riotgames.pvpnet.accountcreation.model.PlayTutorialModel;
   import com.riotgames.pvpnet.accountcreation.model.SummonerNameModel;
   
   public interface IAccountCreationProvider extends IProvider
   {
      
      function getEloQuestionnaireModel() : EloQuestionnaireModel;
      
      function getPlayTutorialModel() : PlayTutorialModel;
      
      function getSummonerNameModel() : SummonerNameModel;
      
      function getChooseIconModel() : ChooseIconModel;
      
      function requestLoadIcons() : void;
      
      function handleStoreIconFulfillment(param1:int, param2:Boolean) : void;
   }
}

