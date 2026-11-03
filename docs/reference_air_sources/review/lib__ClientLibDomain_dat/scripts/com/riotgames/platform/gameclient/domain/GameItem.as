package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class GameItem extends BaseItem
   {
      
      private var _738113884iconName:String;
      
      private var _1033605883buildsIntoItems:ArrayCollection;
      
      private var _477122434displayCategories:ArrayCollection;
      
      private var _1978788562recipeItems:ArrayCollection;
      
      private var _3059661cost:int;
      
      private var _1296516636categories:ArrayCollection;
      
      public function GameItem(param1:Object = null)
      {
         super();
         if(param1 != null)
         {
            this.itemId = param1.itemId;
            this.iconName = param1.iconName;
            this.cost = param1.cost;
            this.recipeItems = new ArrayCollection(param1.recipeItems);
            this.buildsIntoItems = new ArrayCollection(param1.buildsIntoItems);
            this.categories = new ArrayCollection(param1.categories);
            this.gameCode = param1.gameCode;
            this.displayCategories = new ArrayCollection();
         }
      }
      
      public function set iconName(param1:String) : void
      {
         var _loc2_:Object = this._738113884iconName;
         if(_loc2_ !== param1)
         {
            this._738113884iconName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iconName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cost() : int
      {
         return this._3059661cost;
      }
      
      [Bindable(event="propertyChange")]
      public function get recipeItems() : ArrayCollection
      {
         return this._1978788562recipeItems;
      }
      
      public function set cost(param1:int) : void
      {
         var _loc2_:Object = this._3059661cost;
         if(_loc2_ !== param1)
         {
            this._3059661cost = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cost",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get categories() : ArrayCollection
      {
         return this._1296516636categories;
      }
      
      public function set recipeItems(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1978788562recipeItems;
         if(_loc2_ !== param1)
         {
            this._1978788562recipeItems = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"recipeItems",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get iconName() : String
      {
         return this._738113884iconName;
      }
      
      public function set buildsIntoItems(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1033605883buildsIntoItems;
         if(_loc2_ !== param1)
         {
            this._1033605883buildsIntoItems = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buildsIntoItems",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buildsIntoItems() : ArrayCollection
      {
         return this._1033605883buildsIntoItems;
      }
      
      public function set displayCategories(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._477122434displayCategories;
         if(_loc2_ !== param1)
         {
            this._477122434displayCategories = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayCategories",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get displayCategories() : ArrayCollection
      {
         return this._477122434displayCategories;
      }
      
      public function set categories(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1296516636categories;
         if(_loc2_ !== param1)
         {
            this._1296516636categories = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"categories",_loc2_,param1));
         }
      }
   }
}

