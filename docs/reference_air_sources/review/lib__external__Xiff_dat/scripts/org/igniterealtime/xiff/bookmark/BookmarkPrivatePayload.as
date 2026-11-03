package org.igniterealtime.xiff.bookmark
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.privatedata.IPrivatePayload;
   
   public class BookmarkPrivatePayload implements IPrivatePayload
   {
      
      private var _groupChatBookmarks:Array;
      
      private var _urlBookmarks:Array;
      
      private var _others:Array;
      
      public function BookmarkPrivatePayload(param1:Array = null, param2:Array = null)
      {
         var bookmark:GroupChatBookmark = null;
         var urlBookmark:UrlBookmark = null;
         var groupChatBookmarks:Array = param1;
         var urlBookmarks:Array = param2;
         this._groupChatBookmarks = [];
         this._urlBookmarks = new Array();
         this._others = new Array();
         super();
         if(Boolean(groupChatBookmarks))
         {
            for each(bookmark in groupChatBookmarks)
            {
               if(this._groupChatBookmarks.every(function(param1:GroupChatBookmark, param2:int, param3:Array):Boolean
               {
                  return param1.jid != bookmark.jid;
               }))
               {
                  this._groupChatBookmarks.push(bookmark);
               }
            }
         }
         if(Boolean(urlBookmarks))
         {
            for each(urlBookmark in urlBookmarks)
            {
               if(this._urlBookmarks.every(function(param1:UrlBookmark, param2:int, param3:Array):Boolean
               {
                  return param1.url != urlBookmark.url;
               }))
               {
                  this._urlBookmarks.push(urlBookmark);
               }
            }
         }
      }
      
      public function getNS() : String
      {
         return "storage:bookmarks";
      }
      
      public function getElementName() : String
      {
         return "storage";
      }
      
      public function get groupChatBookmarks() : Array
      {
         return this._groupChatBookmarks.slice();
      }
      
      public function get urlBookmarks() : Array
      {
         return this._urlBookmarks.slice();
      }
      
      public function removeGroupChatBookmark(param1:UnescapedJID) : GroupChatBookmark
      {
         var _loc4_:GroupChatBookmark = null;
         var _loc2_:GroupChatBookmark = null;
         var _loc3_:Array = [];
         for each(_loc4_ in this._groupChatBookmarks)
         {
            if(!_loc4_.jid.unescaped.equals(param1,false))
            {
               _loc3_.push(_loc4_);
            }
            else
            {
               _loc2_ = _loc4_;
            }
         }
         this._groupChatBookmarks = _loc3_;
         return _loc2_;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var serializer:Function;
         var parentNode:XMLNode = param1;
         var node:XMLNode = new XMLNode(1,this.getElementName());
         node.attributes.xmlns = this.getNS();
         serializer = function(param1:ISerializable, param2:int, param3:Array):void
         {
            param1.serialize(parentNode);
         };
         this._groupChatBookmarks.forEach(serializer);
         this._urlBookmarks.forEach(serializer);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var child:XMLNode = null;
         var groupChatBookmark:GroupChatBookmark = null;
         var urlBookmark:UrlBookmark = null;
         var bookmarks:XMLNode = param1;
         for each(child in bookmarks.childNodes)
         {
            if(child.nodeName == "conference")
            {
               groupChatBookmark = new GroupChatBookmark();
               groupChatBookmark.deserialize(child);
               if(this._groupChatBookmarks.every(function(param1:GroupChatBookmark, param2:int, param3:Array):Boolean
               {
                  return param1.jid != groupChatBookmark.jid;
               }))
               {
                  this._groupChatBookmarks.push(groupChatBookmark);
               }
            }
            else if(child.nodeName == "url")
            {
               urlBookmark = new UrlBookmark();
               urlBookmark.deserialize(child);
               if(this._urlBookmarks.every(function(param1:UrlBookmark, param2:int, param3:Array):Boolean
               {
                  return param1.url != urlBookmark.url;
               }))
               {
                  this._urlBookmarks.push(urlBookmark);
               }
            }
            else
            {
               this._others.push(child);
            }
         }
         return true;
      }
   }
}

