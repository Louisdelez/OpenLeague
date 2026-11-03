package com.riotgames.pvpnet.tracking.trackers.itemset
{
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class ItemSetsBehaviorTracker extends SessionTimeframedTracker implements IItemSetsBehaviorTracker
   {
      
      public static const ITEM_SETS__PAGES_CREATED___COUNT:String = "item_sets__pages_created.count";
      
      public static const ITEM_SETS__PAGES_RENAMED___COUNT:String = "item_sets__pages_renamed.count";
      
      public static const ITEM_SETS__PAGES_UPDATED_CONTENTS___COUNT:String = "item_sets__pages_updated_contents.count";
      
      public static const ITEM_SETS__PAGES_DELETED___COUNT:String = "item_sets__pages_deleted.count";
      
      public static const ITEM_SETS__ALL_PAGES_REVERTED___COUNT:String = "item_sets__all_pages_reverted.count";
      
      public static const ITEM_SETS__BLOCKS_CREATED___COUNT:String = "item_sets__blocks_created.count";
      
      public static const ITEM_SETS__BLOCKS_RENAMED___COUNT:String = "item_sets__blocks_renamed.count";
      
      public static const ITEM_SETS__BLOCKS_MOVED___COUNT:String = "item_sets__blocks_moved.count";
      
      public static const ITEM_SETS__BLOCKS_UPDATED_CONTENTS___COUNT:String = "item_sets__blocks_updated_contents.count";
      
      public static const ITEM_SETS__BLOCKS_HAD_ITEM_ADDED_TO_CONTENTS___COUNT:String = "item_sets__blocks_had_item_added_to_contents.count";
      
      public static const ITEM_SETS__BLOCKS_ITEM_ADDED_AT_BEGINNING___COUNT:String = "item_sets__blocks_item_added_at_beginning.count";
      
      public static const ITEM_SETS__BLOCKS_ITEM_ADDED_AT_MIDDLE___COUNT:String = "item_sets__blocks_item_added_at_middle.count";
      
      public static const ITEM_SETS__BLOCKS_ITEM_ADDED_AT_END___COUNT:String = "item_sets__blocks_item_added_at_end.count";
      
      public static const ITEM_SETS__BLOCKS_HAD_ITEM_REMOVED_FROM_CONTENTS___COUNT:String = "item_sets__blocks_had_item_removed_from_contents.count";
      
      public static const ITEM_SETS__BLOCKS_DELETED___COUNT:String = "item_sets__blocks_deleted.count";
      
      public static const ITEM_SETS__PAGE_VISITS__WITH_CREATION___COUNT:String = "item_sets__page_visits__with_creation.count";
      
      public static const ITEM_SETS__PAGE_VISITS__WITHOUT_CREATION___COUNT:String = "item_sets__page_visits__without_creation.count";
      
      public static const ITEM_SETS__PAGE_VISITS__TOTAL___COUNT:String = "item_sets__page_visits__total.count";
      
      public static const ITEM_SETS__PAGE_VISITS__WITH_UPDATES_DURATION:String = "item_sets__page_visits__with_updates_duration";
      
      public static const ITEM_SETS__PAGE_VISITS__WITHOUT_UPDATES_DURATION:String = "item_sets__page_visits__without_updates_duration";
      
      public static const ITEM_SETS__PAGE_VISITS__TOTAL_DURATION:String = "item_sets__page_visits__total_duration";
      
      public static const ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_ITEM_TREE___COUNT:String = "item_sets__page_visits__navigation__via_item_tree.count";
      
      public static const ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_CATEGORIES_LIST___COUNT:String = "item_sets__page_visits__navigation__via_categories_list.count";
      
      public static const ITEM_SETS__PAGE_VISITS__NAVIGATION___PREFERENCE:String = "item_sets__page_visits__navigation.preference";
      
      public static const ITEM_SETS__USER_SWITCHED_TO_ITEM_BROWSER_FROM_ITEM_DETAIL___COUNT:String = "item_sets__user_switched_to_item_browser_from_item_detail.count";
      
      public static const ITEM_SETS__USER_SWITCHED_TO_ITEM_DETAIL_FROM_ITEM_BROWSER___COUNT:String = "item_sets__user_switched_to_item_detail_from_item_browser.count";
      
      public static const ITEM_SETS__USER_ITEM_SEARCH_BAR_USED___COUNT:String = "item_sets__user_item_search_bar_used.count";
      
      public static const ITEM_SETS__USER_DRAG_AND_DROP_SUCCESS___COUNT:String = "item_sets__user_drag_and_drop_success.count";
      
      public static const ITEM_SETS__USER_DRAG_AND_DROP_FAILURE___COUNT:String = "item_sets__user_drag_and_drop_failure.count";
      
      public static const ITEM_SETS__USER_DRAG_AND_DROP_TOTAL___COUNT:String = "item_sets__user_drag_and_drop_total.count";
      
      public static const ITEM_SETS__USER_LEFT_CLICKED___COUNT:String = "item_sets__user_left_clicked.count";
      
      public static const ITEM_SETS__USER_RIGHT_CLICKED___COUNT:String = "item_sets__user_right_clicked.count";
      
      public static const ITEM_SETS__USER_DOUBLE_CLICKED___COUNT:String = "item_sets__user_double_clicked.count";
      
      public static const ITEM_SETS__USER_MOUSE_INTERACTED_WITH_ITEM_SET___COUNT:String = "item_sets__user_mouse_interacted_with_item_set.count";
      
      public static const ITEM_SETS__USER_CATEGORY_FILTER_CHECKBOX_CLICKED___COUNT:String = "item_sets__user_category_filter_checkbox_clicked.count";
      
      public static const ITEM_SETS__USER_CATEGORY_ACTUAL_NAME_CLICKED___COUNT:String = "item_sets__user_category_actual_name_clicked.count";
      
      public static const ITEM_SETS__USER_CATEGORY_INTERACTION___PREFERENCE:String = "item_sets__user_category_interaction.preference";
      
      public static const ITEM_SETS__USER_SWITCHED_ACTIVE_ITEM_SET__COUNT:String = "item_sets__user_switched_active_item_set.count";
      
      public static const TEMP_SINGLE_TIME_TRACKER:String = "TEMP_SINGLE_TIME_TRACKER";
      
      public static const FILTER_CHECKBOX:String = "filter_checkbox";
      
      public static const ACTUAL_NAME_CLICKED:String = "actual_name_clicked";
      
      public static const MIXED:String = "mixed";
      
      public static const VIA_ITEM_TREE:String = "via_item_tree";
      
      public static const VIA_BOTH:String = "via_both";
      
      public static const VIA_CATEGORIES_LIST:String = "via_categories_list";
      
      protected var hasMadeChangesThisSession:Boolean = false;
      
      protected var isFirstTime:Boolean = true;
      
      protected var inSession:Boolean = true;
      
      protected var last_item_name:String = null;
      
      private var hasVisitedItemSets:Boolean = false;
      
      public function ItemSetsBehaviorTracker(param1:Boolean = true)
      {
         super("item_sets_behavior",param1);
         isTimer = false;
      }
      
      public function incrementItemSets_BlocksHadItemAddedToContents_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_HAD_ITEM_ADDED_TO_CONTENTS___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_UserDragAndDropSuccess_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_DRAG_AND_DROP_SUCCESS___COUNT);
      }
      
      public function incrementItemSets_BlocksDeleted_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_DELETED___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function stopItemSets_PageVisit() : void
      {
         var _loc1_:Number = NaN;
         get(TEMP_SINGLE_TIME_TRACKER,true).stop();
         _loc1_ = Number(get(TEMP_SINGLE_TIME_TRACKER).getElapsedTimeInMS());
         if(this.hasMadeChangesThisSession)
         {
            this.incrementItemSets_PageVisits_WithCreation_Count_InASession();
            this.recordItemSets_PageVisits_WithUpdatesDuration(_loc1_);
         }
         else
         {
            this.incrementItemSets_PageVisits_WithoutCreation_Count_InASession();
            this.recordItemSets_PageVisits_WithoutUpdatesDuration(_loc1_);
         }
         this.recordItemSets_PageVisits_TotalDuration(_loc1_);
         this.incrementItemSets_PageVisits_Total_Count_InASession();
         this.resetSession();
      }
      
      public function startItemSets_PageVisit() : void
      {
         this.isFirstTime = false;
         this.hasVisitedItemSets = true;
         this.resetSession();
         get(TEMP_SINGLE_TIME_TRACKER,true).start();
         this.inSession = true;
      }
      
      public function incrementItemSets_PageVisits_Navigation_ViaCategoriesList_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_CATEGORIES_LIST___COUNT);
      }
      
      public function recordItemSets_PageVisits_WithoutUpdatesDuration(param1:Number) : void
      {
         recordValue(ITEM_SETS__PAGE_VISITS__WITHOUT_UPDATES_DURATION,param1);
      }
      
      public function incrementItemSets_BlocksCreated_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_CREATED___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_UserDragAndDropTotal_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_DRAG_AND_DROP_TOTAL___COUNT);
      }
      
      public function recordItemSets_PageVisits_WithUpdatesDuration(param1:Number) : void
      {
         recordValue(ITEM_SETS__PAGE_VISITS__WITH_UPDATES_DURATION,param1);
      }
      
      override public function sessionClosed() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(!this.hasVisitedItemSets)
         {
            return;
         }
         if(this.inSession)
         {
            this.stopItemSets_PageVisit();
         }
         remove([TEMP_SINGLE_TIME_TRACKER]);
         if(hasRecording(ITEM_SETS__PAGE_VISITS__WITH_UPDATES_DURATION))
         {
            getRecording(ITEM_SETS__PAGE_VISITS__WITH_UPDATES_DURATION).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__PAGE_VISITS__WITHOUT_UPDATES_DURATION))
         {
            getRecording(ITEM_SETS__PAGE_VISITS__WITHOUT_UPDATES_DURATION).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__PAGE_VISITS__TOTAL_DURATION))
         {
            getRecording(ITEM_SETS__PAGE_VISITS__TOTAL_DURATION).appendParentName = false;
         }
         if(Boolean(hasCounter(ITEM_SETS__USER_CATEGORY_FILTER_CHECKBOX_CLICKED___COUNT)) && Boolean(hasCounter(ITEM_SETS__USER_CATEGORY_ACTUAL_NAME_CLICKED___COUNT)))
         {
            _loc1_ = Number(getCounterValue(ITEM_SETS__USER_CATEGORY_FILTER_CHECKBOX_CLICKED___COUNT));
            _loc2_ = Number(getCounterValue(ITEM_SETS__USER_CATEGORY_ACTUAL_NAME_CLICKED___COUNT));
            _loc3_ = _loc1_ + _loc2_;
            _loc4_ = _loc1_ / _loc3_;
            _loc5_ = _loc2_ / _loc3_;
            _loc6_ = 0.33;
            if(_loc4_ > _loc5_ && _loc4_ >= _loc6_)
            {
               setProperty(ITEM_SETS__USER_CATEGORY_INTERACTION___PREFERENCE,FILTER_CHECKBOX);
            }
            else if(_loc5_ > _loc4_ && _loc6_ <= _loc5_)
            {
               setProperty(ITEM_SETS__USER_CATEGORY_INTERACTION___PREFERENCE,ACTUAL_NAME_CLICKED);
            }
            else
            {
               setProperty(ITEM_SETS__USER_CATEGORY_INTERACTION___PREFERENCE,MIXED);
            }
         }
         else if(Boolean(hasCounter(ITEM_SETS__USER_CATEGORY_FILTER_CHECKBOX_CLICKED___COUNT)) && !hasCounter(ITEM_SETS__USER_CATEGORY_ACTUAL_NAME_CLICKED___COUNT))
         {
            setProperty(ITEM_SETS__USER_CATEGORY_INTERACTION___PREFERENCE,FILTER_CHECKBOX);
         }
         else if(!hasCounter(ITEM_SETS__USER_CATEGORY_FILTER_CHECKBOX_CLICKED___COUNT) && Boolean(hasCounter(ITEM_SETS__USER_CATEGORY_ACTUAL_NAME_CLICKED___COUNT)))
         {
            setProperty(ITEM_SETS__USER_CATEGORY_INTERACTION___PREFERENCE,ACTUAL_NAME_CLICKED);
         }
         _loc7_ = hasCounter(ITEM_SETS__USER_LEFT_CLICKED___COUNT) ? int(getCounterValue(ITEM_SETS__USER_LEFT_CLICKED___COUNT)) : 0;
         _loc7_ = _loc7_ + (hasCounter(ITEM_SETS__USER_DOUBLE_CLICKED___COUNT) ? getCounterValue(ITEM_SETS__USER_DOUBLE_CLICKED___COUNT) : 0);
         _loc7_ = _loc7_ + (hasCounter(ITEM_SETS__USER_DRAG_AND_DROP_TOTAL___COUNT) ? getCounterValue(ITEM_SETS__USER_DRAG_AND_DROP_TOTAL___COUNT) : 0);
         _loc7_ = _loc7_ + (hasCounter(ITEM_SETS__USER_RIGHT_CLICKED___COUNT) ? getCounterValue(ITEM_SETS__USER_RIGHT_CLICKED___COUNT) : 0);
         setProperty(ITEM_SETS__USER_MOUSE_INTERACTED_WITH_ITEM_SET___COUNT,_loc7_);
         if(hasCounter(ITEM_SETS__USER_DRAG_AND_DROP_TOTAL___COUNT))
         {
            _loc8_ = Number(getCounterValue(ITEM_SETS__USER_DRAG_AND_DROP_TOTAL___COUNT));
            if(hasCounter(ITEM_SETS__USER_DRAG_AND_DROP_SUCCESS___COUNT))
            {
               _loc8_ -= getCounterValue(ITEM_SETS__USER_DRAG_AND_DROP_SUCCESS___COUNT);
            }
            setProperty(ITEM_SETS__USER_DRAG_AND_DROP_FAILURE___COUNT);
         }
         if(Boolean(hasCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_ITEM_TREE___COUNT)) && Boolean(hasCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_CATEGORIES_LIST___COUNT)))
         {
            _loc1_ = Number(getCounterValue(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_ITEM_TREE___COUNT));
            _loc2_ = Number(getCounterValue(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_CATEGORIES_LIST___COUNT));
            _loc3_ = _loc1_ + _loc2_;
            _loc4_ = _loc1_ / _loc3_;
            _loc5_ = _loc2_ / _loc3_;
            _loc6_ = 0.33;
            if(_loc4_ > _loc5_ && _loc4_ >= _loc6_)
            {
               setProperty(ITEM_SETS__PAGE_VISITS__NAVIGATION___PREFERENCE,VIA_ITEM_TREE);
            }
            else if(_loc5_ > _loc4_ && _loc6_ <= _loc5_)
            {
               setProperty(ITEM_SETS__PAGE_VISITS__NAVIGATION___PREFERENCE,VIA_CATEGORIES_LIST);
            }
            else
            {
               setProperty(ITEM_SETS__PAGE_VISITS__NAVIGATION___PREFERENCE,VIA_BOTH);
            }
         }
         else if(Boolean(hasCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_ITEM_TREE___COUNT)) && !hasCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_CATEGORIES_LIST___COUNT))
         {
            setProperty(ITEM_SETS__PAGE_VISITS__NAVIGATION___PREFERENCE,VIA_ITEM_TREE);
         }
         else if(!hasCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_ITEM_TREE___COUNT) && Boolean(hasCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_CATEGORIES_LIST___COUNT)))
         {
            setProperty(ITEM_SETS__PAGE_VISITS__NAVIGATION___PREFERENCE,VIA_CATEGORIES_LIST);
         }
         send();
         clearAllCounters();
         reset();
      }
      
      public function incrementItemSets_PagesDeleted_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGES_DELETED___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_AddItemToBlockAtBeginning_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_ITEM_ADDED_AT_BEGINNING___COUNT);
      }
      
      public function incrementItemSets_UserDoubleClicked_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_DOUBLE_CLICKED___COUNT);
      }
      
      public function incrementItemSets_BlocksUpdatedContents_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_UPDATED_CONTENTS___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_UserRightClicked_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_RIGHT_CLICKED___COUNT);
      }
      
      public function incrementItemSets_UserCategoryActualNameClicked_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_CATEGORY_ACTUAL_NAME_CLICKED___COUNT);
      }
      
      public function incrementItemSets_AddItemToBlockAtEnd_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_ITEM_ADDED_AT_END___COUNT);
      }
      
      public function incrementItemSets_BlocksMoved_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_MOVED___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_UserLeftClicked_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_LEFT_CLICKED___COUNT);
      }
      
      public function incrementItemSets_PagesCreated_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGES_CREATED___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_PageVisits_WithoutCreation_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGE_VISITS__WITHOUT_CREATION___COUNT);
      }
      
      public function incrementItemSets_AllPagesReverted_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES_REVERTED___COUNT);
      }
      
      public function incrementItemSets_UserSwitchedToItemDetailFromItemBrowser_Count_InASession(param1:String) : void
      {
         if(this.last_item_name != param1)
         {
            incrementCounter(ITEM_SETS__USER_SWITCHED_TO_ITEM_DETAIL_FROM_ITEM_BROWSER___COUNT);
            this.last_item_name = param1;
         }
      }
      
      public function incrementItemSets_PageVisits_WithCreation_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGE_VISITS__WITH_CREATION___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function recordItemSets_PageVisits_TotalDuration(param1:Number) : void
      {
         recordValue(ITEM_SETS__PAGE_VISITS__TOTAL_DURATION,param1);
      }
      
      public function incrementItemSets_UserItemSearchBarUsed_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_ITEM_SEARCH_BAR_USED___COUNT);
      }
      
      public function incrementItemSets_BlocksHadItemRemovedFromContents_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_HAD_ITEM_REMOVED_FROM_CONTENTS___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_PagesUpdatedContents_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGES_UPDATED_CONTENTS___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_BlocksRenamed_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_RENAMED___COUNT);
         this.hasMadeChangesThisSession = true;
      }
      
      public function incrementItemSets_UserCategoryFilterCheckboxClicked_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_CATEGORY_FILTER_CHECKBOX_CLICKED___COUNT);
      }
      
      public function incrementItemSets_UserDragAndDropFailure_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_DRAG_AND_DROP_FAILURE___COUNT);
      }
      
      public function incrementItemSets_PageVisits_Navigation_ViaItemTree_Count_InASession(param1:String) : void
      {
         if(this.last_item_name != param1)
         {
            incrementCounter(ITEM_SETS__PAGE_VISITS__NAVIGATION__VIA_ITEM_TREE___COUNT);
            this.last_item_name = param1;
         }
      }
      
      public function incrementItemSets_AddItemToBlockAtMiddle_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__BLOCKS_ITEM_ADDED_AT_MIDDLE___COUNT);
      }
      
      protected function resetSession() : void
      {
         this.hasMadeChangesThisSession = false;
         this.inSession = false;
         get(TEMP_SINGLE_TIME_TRACKER,true).reset();
      }
      
      public function incrementItemSets_PageVisits_Total_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGE_VISITS__TOTAL___COUNT);
      }
      
      public function incrementItemSets_UserMouseInteractedWithItemSet_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_MOUSE_INTERACTED_WITH_ITEM_SET___COUNT);
      }
      
      public function incrementItemSets_UserSwitchedActiveItemSet_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_SWITCHED_ACTIVE_ITEM_SET__COUNT);
      }
      
      public function incrementItemSets_UserSwitchedToItemBrowserFromItemDetail_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__USER_SWITCHED_TO_ITEM_BROWSER_FROM_ITEM_DETAIL___COUNT);
      }
      
      public function incrementItemSets_PagesRenamed_Count_InASession() : void
      {
         incrementCounter(ITEM_SETS__PAGES_RENAMED___COUNT);
         this.hasMadeChangesThisSession = true;
      }
   }
}

