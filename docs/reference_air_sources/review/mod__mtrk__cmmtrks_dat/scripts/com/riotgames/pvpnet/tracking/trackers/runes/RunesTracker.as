package com.riotgames.pvpnet.tracking.trackers.runes
{
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class RunesTracker extends SessionTimeframedTracker implements IRunesTracker
   {
      
      private static const RUNES__TOTAL_PAGES___COUNT:String = "runes__total_pages.count";
      
      private static const RUNES__TOTAL_OWNED_MARKS___COUNT:String = "runes__total_owned_marks.count";
      
      private static const RUNES__TOTAL_OWNED_SEALS___COUNT:String = "runes__total_owned_seals.count";
      
      private static const RUNES__TOTAL_OWNED_GLYPHS___COUNT:String = "runes__total_owned_glyphs.count";
      
      private static const RUNES__TOTAL_OWNED_QUINTS___COUNT:String = "runes__total_owned_quints.count";
      
      private static const RUNES__TOTAL_OWNED_TIER_1___COUNT:String = "runes__total_owned_tier1.count";
      
      private static const RUNES__TOTAL_OWNED_TIER_2___COUNT:String = "runes__total_owned_tier2.count";
      
      private static const RUNES__TOTAL_OWNED_TIER_3___COUNT:String = "runes__total_owned_tier3.count";
      
      private static const RUNES__TOTAL_OWNED_RUNES___COUNT:String = "runes__total_owned_runes.count";
      
      private static const RUNES__PAGES_WITH_RUNES___COUNT:String = "runes__pages_with_runes.count";
      
      private static const RUNES__PAGES_WITH_RUNES___PERCENTAGE:String = "runes__pages_with_runes.percentage";
      
      private static const RUNES__PAGES_WITH_MIXED_RUNE_TYPES__COUNT:String = "runes__pages_with_mixed_runes.count";
      
      private static const RUNES__PAGES_WITH_MIXED_RUNE_TYPES__PERCENTAGE:String = "runes__pages_with_mixed_runes.percentage";
      
      private static const RUNES__PAGE_NAMES:String = "runes__page_names";
      
      private static const RUNES__OVERALL_STYLE:String = "runes__overall_style";
      
      private static const RUNES__PAGES_RENAMED___COUNT:String = "runes__pages_renamed.count";
      
      private static const RUNES__USER_RIGHT_CLICKED_TO_ADD_TO_PAGE___COUNT:String = "runes__user_right_clicked_to_add_to_page.count";
      
      private static const RUNES__USER_DOUBLE_CLICKED_TO_ADD_TO_PAGE___COUNT:String = "runes__user_double_clicked_to_add_to_page.count";
      
      private static const RUNES__USER_RIGHT_CLICKED_TO_REMOVE_FROM_PAGE___COUNT:String = "runes__user_right_clicked_to_remove_from_page.count";
      
      private static const RUNES__USER_DOUBLE_CLICKED_TO_REMOVE_FROM_PAGE___COUNT:String = "runes__user_double_clicked_to_remove_from_page.count";
      
      private static const RUNES__USER_DRAG_AND_DROP_ADD_NON_SPECIFIC_SLOT___COUNT:String = "runes__user_drag_and_drop_add_nonspecific_slot.count";
      
      private static const RUNES__USER_DRAG_AND_DROP_ADD_SPECIFIC_SLOT___COUNT:String = "runes__user_drag_and_drop_add_specific_slot.count";
      
      private static const RUNES__USER_DRAG_AND_DROP_ADD_TOTAL___COUNT:String = "runes__user_drag_and_drop_add_total.count";
      
      private static const RUNES__USER_DRAG_AND_DROP_REMOVE_TOTAL___COUNT:String = "runes__user_drag_and_drop_remove.count";
      
      private static const RUNES__PAGE_VISITS__WITH_UPDATES___DURATION:String = "runes__page_visits__with_updates.duration";
      
      private static const RUNES__PAGE_VISITS__WITHOUT_UPDATES___DURATION:String = "runes__page_visits__without_updates.duration";
      
      private static const RUNES__PAGE_VISITS__TOTAL___DURATION:String = "runes__page_visits__total.duration";
      
      private static const RUNES__SAVE_CLICKED___COUNT:String = "runes__save_clicked.count";
      
      private static const RUNES__CLEAR_CLICKED___COUNT:String = "runes__clear_clicked.count";
      
      private static const RUNES__REVERT_CLICKED___COUNT:String = "runes__revert_clicked.count";
      
      private static const RUNES__CATEGORY_FILTER_CHANGED___COUNT:String = "runes__category_filter_changed.count";
      
      private static const RUNES__TIER_FILTER_CHANGED___COUNT:String = "runes__tier_filter_changed.count";
      
      private static const RUNES__COMBINER_COMBINES___COUNT:String = "runes__combiner_combines.count";
      
      private static const RUNES__COMBINER_OPENED___COUNT:String = "runes__combiner_opened.count";
      
      private static const TEMP_SINGLE_TIME_TRACKER:String = "TEMP_SINGLE_TIME_TRACKER";
      
      private var hasMadeChangesThisSession:Boolean = false;
      
      private var inSession:Boolean = true;
      
      private var hasVisitedRunes:Boolean = false;
      
      public function RunesTracker(param1:Boolean = true)
      {
         super("runes",param1);
         isTimer = false;
      }
      
      public function setRunes_TotalOwnedGlyphs_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_GLYPHS___COUNT,param1);
      }
      
      public function setRunes_TotalOwnedQuints_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_QUINTS___COUNT,param1);
      }
      
      public function incrementRunes_RevertClicked_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = false;
         incrementCounter(RUNES__REVERT_CLICKED___COUNT);
      }
      
      public function incrementRunes_UserDragAndDropToAddSpecificSlot_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_DRAG_AND_DROP_ADD_SPECIFIC_SLOT___COUNT);
      }
      
      public function incrementRunes_UserRightClickedToRemove_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_RIGHT_CLICKED_TO_REMOVE_FROM_PAGE___COUNT);
      }
      
      public function recordRunes_PageVisits_WithUpdatesDuration(param1:Number) : void
      {
         recordValue(RUNES__PAGE_VISITS__WITH_UPDATES___DURATION,param1);
      }
      
      public function setRunes_TotalOwnedMarks_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_MARKS___COUNT,param1);
      }
      
      public function incrementRunes_CombinerOpened_Count_InASession() : void
      {
         incrementCounter(RUNES__COMBINER_OPENED___COUNT);
      }
      
      public function incrementRunes_UserDragAndDropToAddTotal_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_DRAG_AND_DROP_ADD_TOTAL___COUNT);
      }
      
      public function setRunes_TotalOwnedTier1_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_TIER_1___COUNT,param1);
      }
      
      public function incrementRunes_UserDragAndDropToAddNonSpecificSlot_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_DRAG_AND_DROP_ADD_NON_SPECIFIC_SLOT___COUNT);
      }
      
      override public function sessionClosed() : void
      {
         if(!this.hasVisitedRunes)
         {
            return;
         }
         if(this.inSession)
         {
            this.stopRunes_PageVisit();
         }
         remove([TEMP_SINGLE_TIME_TRACKER]);
         if(hasRecording(RUNES__PAGE_VISITS__WITH_UPDATES___DURATION))
         {
            getRecording(RUNES__PAGE_VISITS__WITH_UPDATES___DURATION).appendParentName = false;
         }
         if(hasRecording(RUNES__PAGE_VISITS__WITHOUT_UPDATES___DURATION))
         {
            getRecording(RUNES__PAGE_VISITS__WITHOUT_UPDATES___DURATION).appendParentName = false;
         }
         if(hasRecording(RUNES__PAGE_VISITS__TOTAL___DURATION))
         {
            getRecording(RUNES__PAGE_VISITS__TOTAL___DURATION).appendParentName = false;
         }
         super.sessionClosed();
      }
      
      public function incrementRunes_TierFilterChanged_Count_InASession() : void
      {
         incrementCounter(RUNES__TIER_FILTER_CHANGED___COUNT);
      }
      
      public function recordRunes_PageVisits_WithoutUpdatesDuration(param1:Number) : void
      {
         recordValue(RUNES__PAGE_VISITS__WITHOUT_UPDATES___DURATION,param1);
      }
      
      public function setRunes_TotalOwnedRunes_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_RUNES___COUNT,param1);
      }
      
      public function setRunes_TotalOwnedTier3_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_TIER_3___COUNT,param1);
      }
      
      public function setRunes_PagesWithMixedRunes_Percentage(param1:Number) : void
      {
         setCounterValue(RUNES__PAGES_WITH_MIXED_RUNE_TYPES__PERCENTAGE,param1);
      }
      
      public function stopRunes_PageVisit() : void
      {
         get(TEMP_SINGLE_TIME_TRACKER).stop();
         var _loc1_:Number = Number(get(TEMP_SINGLE_TIME_TRACKER).getElapsedTimeInMS());
         if(this.hasMadeChangesThisSession)
         {
            this.recordRunes_PageVisits_WithUpdatesDuration(_loc1_);
         }
         else
         {
            this.recordRunes_PageVisits_WithoutUpdatesDuration(_loc1_);
         }
         this.recordRunes_PageVisits_TotalDuration(_loc1_);
         this.resetSession();
      }
      
      public function incrementRunes_PageRenamed_Count_InASession() : void
      {
         incrementCounter(RUNES__PAGES_RENAMED___COUNT);
      }
      
      public function setRunes_PagesWithRunes_Count(param1:Number) : void
      {
         setCounterValue(RUNES__PAGES_WITH_RUNES___COUNT,param1);
      }
      
      public function incrementRunes_CategoryFilterChanged_Count_InASession() : void
      {
         incrementCounter(RUNES__CATEGORY_FILTER_CHANGED___COUNT);
      }
      
      public function setRunes_PagesWithMixedRunes_Count(param1:Number) : void
      {
         setCounterValue(RUNES__PAGES_WITH_MIXED_RUNE_TYPES__COUNT,param1);
      }
      
      public function setRunes_PageNames(param1:Array) : void
      {
         setProperty(RUNES__PAGE_NAMES,param1.join(";"));
      }
      
      public function incrementRunes_CombinerCombines_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__COMBINER_COMBINES___COUNT);
      }
      
      public function incrementRunes_UserRightClickedToAdd_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_RIGHT_CLICKED_TO_ADD_TO_PAGE___COUNT);
      }
      
      private function resetSession() : void
      {
         this.hasMadeChangesThisSession = false;
         this.inSession = false;
         get(TEMP_SINGLE_TIME_TRACKER,true).reset();
      }
      
      public function setRunes_TotalOwnedTier2_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_TIER_2___COUNT,param1);
      }
      
      public function incrementRunes_ClearClicked_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__CLEAR_CLICKED___COUNT);
      }
      
      public function incrementRunes_SaveClicked_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__SAVE_CLICKED___COUNT);
      }
      
      public function setRunes_TotalOwnedSeals_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_OWNED_SEALS___COUNT,param1);
      }
      
      public function incrementRunes_UserDragAndDropToRemoveTotal_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_DRAG_AND_DROP_REMOVE_TOTAL___COUNT);
      }
      
      public function recordRunes_PageVisits_TotalDuration(param1:Number) : void
      {
         recordValue(RUNES__PAGE_VISITS__TOTAL___DURATION,param1);
      }
      
      public function setRunes_PagesWithRunes_Percentage(param1:Number) : void
      {
         setCounterValue(RUNES__PAGES_WITH_RUNES___PERCENTAGE,param1);
      }
      
      public function incrementRunes_UserDoubleClickedToRemove_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_DOUBLE_CLICKED_TO_REMOVE_FROM_PAGE___COUNT);
      }
      
      public function setOverallStyle(param1:String) : void
      {
         setProperty(RUNES__OVERALL_STYLE,param1);
      }
      
      public function startRunes_PageVisit() : void
      {
         this.hasVisitedRunes = true;
         this.resetSession();
         get(TEMP_SINGLE_TIME_TRACKER,true).start();
         this.inSession = true;
      }
      
      public function incrementRunes_UserDoubleClickedToAdd_Count_InASession() : void
      {
         this.hasMadeChangesThisSession = true;
         incrementCounter(RUNES__USER_DOUBLE_CLICKED_TO_ADD_TO_PAGE___COUNT);
      }
      
      public function setRunes_TotalPages_Count(param1:Number) : void
      {
         setCounterValue(RUNES__TOTAL_PAGES___COUNT,param1);
      }
   }
}

