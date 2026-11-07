package mx.utils
{
   import flash.filesystem.File;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   
   [ExcludeClass]
   public class DirectoryEnumeration
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var extensionsSet:Object;
      
      private var _collection:ArrayCollection;
      
      private var _enumerationMode:String = DirectoryEnumerationMode.DIRECTORIES_FIRST;
      
      private var _extensions:Array;
      
      private var _filterFunction:Function;
      
      private var _nameCompareFunction:Function;
      
      private var _showHidden:Boolean = false;
      
      private var _source:Array;
      
      public function DirectoryEnumeration(source:Array = null)
      {
         super();
         this.source = source;
      }
      
      public function get collection() : ArrayCollection
      {
         return this._collection;
      }
      
      public function get enumerationMode() : String
      {
         return this._enumerationMode;
      }
      
      public function set enumerationMode(value:String) : void
      {
         this._enumerationMode = value;
      }
      
      public function get extensions() : Array
      {
         return this._extensions;
      }
      
      public function set extensions(value:Array) : void
      {
         var s:String = null;
         this._extensions = value;
         this.extensionsSet = {};
         for each(s in this.extensions)
         {
            if(s.charAt(0) == ".")
            {
               s = s.substr(1);
            }
            this.extensionsSet[s.toLowerCase()] = true;
         }
      }
      
      public function get filterFunction() : Function
      {
         return this._filterFunction;
      }
      
      public function set filterFunction(value:Function) : void
      {
         this._filterFunction = value;
      }
      
      public function get nameCompareFunction() : Function
      {
         return this._nameCompareFunction;
      }
      
      public function set nameCompareFunction(value:Function) : void
      {
         this._nameCompareFunction = value;
      }
      
      public function get showHidden() : Boolean
      {
         return this._showHidden;
      }
      
      public function set showHidden(value:Boolean) : void
      {
         this._showHidden = value;
      }
      
      public function get source() : Array
      {
         return this._source;
      }
      
      public function set source(value:Array) : void
      {
         this._source = value;
         this._collection = new ArrayCollection(this.source);
         this._collection.filterFunction = this.fileFilterFunction;
         this._collection.sort = new Sort();
         this._collection.sort.compareFunction = this.fileCompareFunction;
         this._collection.refresh();
      }
      
      public function refresh() : void
      {
         this._collection.refresh();
      }
      
      public function fileFilterFunction(file:File) : Boolean
      {
         var extension:String = null;
         if(!file.exists)
         {
            return false;
         }
         if(!this.showHidden && Boolean(file.isHidden) && Boolean(file.parent))
         {
            return false;
         }
         if(this.enumerationMode == DirectoryEnumerationMode.FILES_ONLY && Boolean(file.isDirectory) || this.enumerationMode == DirectoryEnumerationMode.DIRECTORIES_ONLY && !file.isDirectory)
         {
            return false;
         }
         if(Boolean(this.extensions) && !file.isDirectory)
         {
            extension = file.extension;
            if(!extension || !this.extensionsSet[extension.toLowerCase()])
            {
               return false;
            }
         }
         return Boolean(this.filterFunction != null ? this.filterFunction(file) : true);
      }
      
      public function fileCompareFunction(file1:File, file2:File, fields:Array = null) : int
      {
         if(Boolean(file1.isDirectory) && !file2.isDirectory)
         {
            if(this.enumerationMode == DirectoryEnumerationMode.DIRECTORIES_FIRST)
            {
               return -1;
            }
            if(this.enumerationMode == DirectoryEnumerationMode.FILES_FIRST)
            {
               return 1;
            }
         }
         if(!file1.isDirectory && Boolean(file2.isDirectory))
         {
            if(this.enumerationMode == DirectoryEnumerationMode.DIRECTORIES_FIRST)
            {
               return 1;
            }
            if(this.enumerationMode == DirectoryEnumerationMode.FILES_FIRST)
            {
               return -1;
            }
         }
         return this.nameCompareFunction != null ? int(this.nameCompareFunction(file1.name,file2.name)) : this.defaultNameCompareFunction(file1.name,file2.name);
      }
      
      protected function defaultNameCompareFunction(name1:String, name2:String) : int
      {
         name1 = name1.toLocaleLowerCase();
         name2 = name2.toLocaleLowerCase();
         if(name1 < name2)
         {
            return -1;
         }
         if(name1 > name2)
         {
            return 1;
         }
         return 0;
      }
   }
}

