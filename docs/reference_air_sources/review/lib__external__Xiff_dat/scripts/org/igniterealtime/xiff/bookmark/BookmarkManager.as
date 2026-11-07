package org.igniterealtime.xiff.bookmark
{
   import flash.events.EventDispatcher;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.privatedata.PrivateDataExtension;
   import org.igniterealtime.xiff.events.BookmarkChangedEvent;
   import org.igniterealtime.xiff.events.BookmarkRetrievedEvent;
   import org.igniterealtime.xiff.privatedata.PrivateDataManager;
   import org.igniterealtime.xiff.util.Callback;
   
   [Event("GroupChatBookmarkChanged")]
   public class BookmarkManager extends EventDispatcher
   {
      
      private static var bookmarkManagerConstructed:Boolean = bookmarkManagerStaticConstructor();
      
      private var _privateDataManager:PrivateDataManager;
      
      private var _bookmarks:BookmarkPrivatePayload;
      
      public function BookmarkManager(param1:PrivateDataManager)
      {
         super();
         this._privateDataManager = param1;
      }
      
      private static function bookmarkManagerStaticConstructor() : Boolean
      {
         ExtensionClassRegistry.register(BookmarkPrivatePayload);
         return true;
      }
      
      public function fetchBookmarks() : void
      {
         if(!this._bookmarks)
         {
            this._privateDataManager.getPrivateData("storage","storage:bookmarks",new Callback(this,this["_processBookmarks"]));
         }
         else
         {
            dispatchEvent(new BookmarkRetrievedEvent());
         }
      }
      
      public function addGroupChatBookmark(param1:GroupChatBookmark) : void
      {
         if(!this._bookmarks)
         {
            this._privateDataManager.getPrivateData("storage","storage:bookmarks",new Callback(this,this["_processBookmarksAdd"],param1));
         }
         else
         {
            this._addBookmark(param1);
         }
      }
      
      public function isGroupChatBookmarked(param1:UnescapedJID) : Boolean
      {
         var _loc2_:GroupChatBookmark = null;
         for each(_loc2_ in this._bookmarks.groupChatBookmarks)
         {
            if(_loc2_.jid.unescaped.equals(param1,false))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getGroupChatBookmark(param1:UnescapedJID) : GroupChatBookmark
      {
         var _loc2_:GroupChatBookmark = null;
         for each(_loc2_ in this._bookmarks.groupChatBookmarks)
         {
            if(_loc2_.jid.unescaped.equals(param1,false))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function removeGroupChatBookmark(param1:UnescapedJID) : void
      {
         if(!this._bookmarks)
         {
            this._privateDataManager.getPrivateData("storage","storage:bookmarks",new Callback(this,this["_processBookmarksRemove"],param1));
         }
         else
         {
            this._removeBookmark(param1);
         }
      }
      
      public function setAutoJoin(param1:UnescapedJID, param2:Boolean) : void
      {
         if(!this._bookmarks)
         {
            this._privateDataManager.getPrivateData("storage","storage:bookmarks",new Callback(this,this["_processBookmarksSetAuto"],param1,param2));
         }
         else
         {
            this._setAutoJoin(param1,param2);
         }
      }
      
      public function get bookmarks() : BookmarkPrivatePayload
      {
         return this._bookmarks;
      }
      
      private function _processBookmarks(param1:XMPPStanza) : void
      {
         var _loc2_:PrivateDataExtension = param1.getAllExtensionsByNS("jabber:iq:private")[0];
         this._bookmarks = BookmarkPrivatePayload(_loc2_.payload);
         dispatchEvent(new BookmarkRetrievedEvent());
      }
      
      private function _processBookmarksAdd(param1:ISerializable, param2:XMPPStanza) : void
      {
         this._processBookmarks(param2);
         this._addBookmark(param1);
      }
      
      private function _processBookmarksRemove(param1:UnescapedJID, param2:XMPPStanza) : void
      {
         this._processBookmarks(param2);
         this._removeBookmark(param1);
      }
      
      private function _processBookmarksSetAuto(param1:UnescapedJID, param2:Boolean, param3:XMPPStanza) : void
      {
         this._processBookmarks(param3);
         this._setAutoJoin(param1,param2);
      }
      
      private function _addBookmark(param1:ISerializable) : void
      {
         var _loc2_:Array = this._bookmarks.groupChatBookmarks;
         var _loc3_:Array = this._bookmarks.urlBookmarks;
         if(param1 is GroupChatBookmark)
         {
            _loc2_.push(param1);
         }
         else if(param1 is UrlBookmark)
         {
            _loc3_.push(param1);
         }
         var _loc4_:BookmarkPrivatePayload = new BookmarkPrivatePayload(_loc2_,_loc3_);
         this._privateDataManager.setPrivateData("storage","storage:bookmarks",_loc4_);
         this._bookmarks = _loc4_;
         dispatchEvent(new BookmarkChangedEvent(BookmarkChangedEvent.GROUPCHAT_BOOKMARK_ADDED,param1));
      }
      
      private function _removeBookmark(param1:UnescapedJID) : void
      {
         var _loc2_:GroupChatBookmark = this._bookmarks.removeGroupChatBookmark(param1);
         this._updateBookmarks();
         dispatchEvent(new BookmarkChangedEvent(BookmarkChangedEvent.GROUPCHAT_BOOKMARK_REMOVED,_loc2_));
      }
      
      private function _setAutoJoin(param1:UnescapedJID, param2:Boolean) : void
      {
         var _loc3_:GroupChatBookmark = null;
         for each(_loc3_ in this._bookmarks.groupChatBookmarks)
         {
            if(_loc3_.jid.unescaped.equals(param1,false))
            {
               _loc3_.autoJoin = param2;
            }
         }
         this._updateBookmarks();
      }
      
      private function _updateBookmarks() : void
      {
         var _loc1_:Array = this._bookmarks.groupChatBookmarks;
         var _loc2_:Array = this._bookmarks.urlBookmarks;
         var _loc3_:BookmarkPrivatePayload = new BookmarkPrivatePayload(_loc1_,_loc2_);
         this._privateDataManager.setPrivateData("storage","storage:bookmarks",_loc3_);
      }
   }
}

