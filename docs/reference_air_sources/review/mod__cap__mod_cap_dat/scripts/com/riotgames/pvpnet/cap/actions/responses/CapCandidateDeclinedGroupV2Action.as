package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   
   public class CapCandidateDeclinedGroupV2Action extends CapCandidateDeclinedV2Action
   {
      
      public static const METHOD_NAME:String = "candidateDeclinedGroupV2";
      
      private var _soundProvider:ISoundProvider;
      
      public function CapCandidateDeclinedGroupV2Action(param1:String, param2:CapModel, param3:IDecode, param4:ISoundProvider)
      {
         this._soundProvider = param4;
         super(param1,param2,param3);
      }
      
      override protected function updateDeclinedPlayer(param1:CapPlayerSelection) : void
      {
         super.updateDeclinedPlayer(param1);
         param1.errorText = CapLocaleUtil.getResourceString("gf_candidate_error_player_not_available","The player was not available. Searching for another candidate...");
         this._soundProvider.play(CapAudioKeys.CAP_SOLO_DECLINES_GROUP);
      }
   }
}

