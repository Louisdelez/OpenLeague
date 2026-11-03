package org.papervision3d.materials
{
   import flash.utils.Dictionary;
   import org.papervision3d.core.proto.MaterialObject3D;
   
   public class MaterialsList
   {
      
      public var materialsByName:Dictionary;
      
      protected var _materials:Dictionary;
      
      private var _materialsTotal:int;
      
      public function MaterialsList(materials:* = null)
      {
         var i:String = null;
         var name:String = null;
         super();
         this.materialsByName = new Dictionary(true);
         this._materials = new Dictionary(false);
         this._materialsTotal = 0;
         if(Boolean(materials))
         {
            if(materials is Array)
            {
               for(i in materials)
               {
                  this.addMaterial(materials[i]);
               }
            }
            else if(materials is Object)
            {
               for(name in materials)
               {
                  this.addMaterial(materials[name],name);
               }
            }
         }
      }
      
      public function get numMaterials() : int
      {
         return this._materialsTotal;
      }
      
      public function addMaterial(material:MaterialObject3D, name:String = null) : MaterialObject3D
      {
         name = name || material.name || String(material.id);
         this._materials[material] = name;
         this.materialsByName[name] = material;
         ++this._materialsTotal;
         return material;
      }
      
      public function removeMaterial(material:MaterialObject3D) : MaterialObject3D
      {
         delete this.materialsByName[this._materials[material]];
         delete this._materials[material];
         return material;
      }
      
      public function toString() : String
      {
         var list:String = null;
         var m:MaterialObject3D = null;
         list = "";
         for each(m in this.materialsByName)
         {
            list += this._materials[m] + "\n";
         }
         return list;
      }
      
      public function removeMaterialByName(name:String) : MaterialObject3D
      {
         return removeMaterial(getMaterialByName(name));
      }
      
      public function clone() : MaterialsList
      {
         var cloned:MaterialsList = null;
         var m:MaterialObject3D = null;
         cloned = new MaterialsList();
         for each(m in this.materialsByName)
         {
            cloned.addMaterial(m.clone(),this._materials[m]);
         }
         return cloned;
      }
      
      public function getMaterialByName(name:String) : MaterialObject3D
      {
         return Boolean(this.materialsByName[name]) ? this.materialsByName[name] : this.materialsByName["all"];
      }
   }
}

