package com.riotgames.platform.gameclient.chat.domain
{
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.controls.treeClasses.ITreeDataDescriptor;
   
   public class BuddyDataDescriptor implements ITreeDataDescriptor
   {
      
      public function BuddyDataDescriptor()
      {
         super();
      }
      
      public function getData(param1:Object, param2:Object = null) : Object
      {
         return Object(param1);
      }
      
      public function removeChildAt(param1:Object, param2:Object, param3:int, param4:Object = null) : Boolean
      {
         return false;
      }
      
      public function hasChildren(param1:Object, param2:Object = null) : Boolean
      {
         return param1 is ArrayCollection;
      }
      
      public function isBranch(param1:Object, param2:Object = null) : Boolean
      {
         return param1 is ArrayCollection;
      }
      
      public function getChildren(param1:Object, param2:Object = null) : ICollectionView
      {
         if(param1 is ArrayCollection)
         {
            return param1 as ICollectionView;
         }
         return null;
      }
      
      public function addChildAt(param1:Object, param2:Object, param3:int, param4:Object = null) : Boolean
      {
         return false;
      }
   }
}

