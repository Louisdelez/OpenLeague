package com.riotgames.pvpnet.accountcreation.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class EloQuestionnaireModel
   {
      
      private var _pendingSkillLevelValueChanged:Signal = new Signal();
      
      private var _skillLevelValueConfirmed:Signal = new Signal();
      
      public function EloQuestionnaireModel()
      {
         super();
      }
      
      public function getPendingSkillLevelValueChanged() : ISignal
      {
         return this._pendingSkillLevelValueChanged;
      }
      
      public function set pendingSkillLevelValue(param1:String) : void
      {
         this._pendingSkillLevelValueChanged.dispatch(param1);
      }
      
      public function getSkillLevelValueConfirmed() : ISignal
      {
         return this._skillLevelValueConfirmed;
      }
      
      public function set skillLevelValue(param1:String) : void
      {
         this._skillLevelValueConfirmed.dispatch(param1);
      }
   }
}

