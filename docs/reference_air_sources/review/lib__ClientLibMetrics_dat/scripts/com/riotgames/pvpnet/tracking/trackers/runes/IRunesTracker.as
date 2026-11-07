package com.riotgames.pvpnet.tracking.trackers.runes
{
   public interface IRunesTracker
   {
      
      function setOverallStyle(param1:String) : void;
      
      function setRunes_TotalPages_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedMarks_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedSeals_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedGlyphs_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedQuints_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedTier1_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedTier2_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedTier3_Count(param1:Number) : void;
      
      function setRunes_TotalOwnedRunes_Count(param1:Number) : void;
      
      function setRunes_PagesWithRunes_Count(param1:Number) : void;
      
      function setRunes_PagesWithRunes_Percentage(param1:Number) : void;
      
      function setRunes_PageNames(param1:Array) : void;
      
      function setRunes_PagesWithMixedRunes_Count(param1:Number) : void;
      
      function setRunes_PagesWithMixedRunes_Percentage(param1:Number) : void;
      
      function incrementRunes_PageRenamed_Count_InASession() : void;
      
      function incrementRunes_UserRightClickedToAdd_Count_InASession() : void;
      
      function incrementRunes_UserDoubleClickedToAdd_Count_InASession() : void;
      
      function incrementRunes_UserRightClickedToRemove_Count_InASession() : void;
      
      function incrementRunes_UserDoubleClickedToRemove_Count_InASession() : void;
      
      function incrementRunes_UserDragAndDropToAddNonSpecificSlot_Count_InASession() : void;
      
      function incrementRunes_UserDragAndDropToAddSpecificSlot_Count_InASession() : void;
      
      function incrementRunes_UserDragAndDropToAddTotal_Count_InASession() : void;
      
      function incrementRunes_UserDragAndDropToRemoveTotal_Count_InASession() : void;
      
      function incrementRunes_CategoryFilterChanged_Count_InASession() : void;
      
      function incrementRunes_TierFilterChanged_Count_InASession() : void;
      
      function recordRunes_PageVisits_WithUpdatesDuration(param1:Number) : void;
      
      function recordRunes_PageVisits_WithoutUpdatesDuration(param1:Number) : void;
      
      function recordRunes_PageVisits_TotalDuration(param1:Number) : void;
      
      function incrementRunes_RevertClicked_Count_InASession() : void;
      
      function incrementRunes_SaveClicked_Count_InASession() : void;
      
      function incrementRunes_ClearClicked_Count_InASession() : void;
      
      function incrementRunes_CombinerCombines_Count_InASession() : void;
      
      function incrementRunes_CombinerOpened_Count_InASession() : void;
      
      function startRunes_PageVisit() : void;
      
      function stopRunes_PageVisit() : void;
   }
}

