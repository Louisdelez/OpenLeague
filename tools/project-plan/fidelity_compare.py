"""Explicit representation comparisons; unknown semantics never become equality."""
import math,re
def numeric(v,allow_packed_bool=False):
 if isinstance(v,bool) and not allow_packed_bool:return None
 if v is None:return None
 try:
  n=float(v);return n if math.isfinite(n) else None
 except (ValueError,TypeError):return None
def close(a,b):
 a=numeric(a,True);b=numeric(b,True)
 return a is not None and b is not None and abs(a-b)<=max(1e-5,abs(b)*1e-6)
def boolean_lexeme(v):
 if isinstance(v,bool):return v
 if isinstance(v,str):return {'true':True,'yes':True,'false':False,'no':False}.get(v.casefold())
 return None
def vector(v):
 if isinstance(v,list):return v if all(numeric(x,True) is not None for x in v) else None
 if isinstance(v,str) and re.fullmatch(r'[\s,;0-9.eE+\-]+',v):
  values=[numeric(x) for x in re.split(r'[\s,;]+',v.strip()) if x]
  if len(values)>1 and all(x is not None for x in values):return values
 return None
def mirror_relation(native,community,key):
 if native==community or close(native,community):return 'numeric_or_exact_match'
 a=boolean_lexeme(native);b=boolean_lexeme(community)
 if a is not None and b is not None and a==b:return 'equivalent_boolean_lexemes'
 a=vector(native);b=vector(community)
 if a is not None and b is not None and len(a)==len(b) and all(close(x,y) for x,y in zip(a,b)):return 'equivalent_vector_encoding'
 a=numeric(native);b=numeric(community)
 if key=='Flags' and a is not None and b is not None and a.is_integer() and b.is_integer() and int(a)&0xffffffff==int(b)&0xffffffff:return 'equivalent_signed_unsigned_u32_bitpattern'
 return 'unresolved_value_or_semantic_difference'
def catalogue_relation(row,current_regen=None,not_purchasable=False):
 status=row['status']
 if status=='equal':return {'status':'equal','selected':'same_value','mechanical_adoption_qualified':False}
 if status in ['display_value_matches_named_native_field','non_numeric_self_display']:
  return {'status':'separate_display_semantics','selected':'catalogue display value retained separately from server reach; raw native sentinel not promoted','mechanical_adoption_qualified':False}
 if status=='divergent' and row['family']=='champion_regen' and current_regen is not None and close(current_regen,row.get('native_raw')):
  return {'status':'resolved_current_native_regeneration','selected':'native per-second value already used by actual regeneration consumer','runtime_value':current_regen,'catalogue_display_per5seconds':row['catalogue'],'mechanical_adoption_qualified':True,'limit':'Native runtime/default overrides remain outside this static consumer check.'}
 if status=='divergent' and row['family']=='champion_spell_effect' and row['subject'] in ['Azir:0','Lissandra:0','Lissandra:3'] and close(-100*float(row['native']),row['catalogue']):
  return {'status':'signed_fraction_vs_display_percent','selected':'preserve signed native fraction and positive display percent separately','conversion':'display=-100*native','mechanical_adoption_qualified':False,'limit':'Mathematical representation agreement does not prove the original server slow implementation.'}
 if status=='divergent' and row['family']=='item_recipe_component' and numeric(row['native'],True)==0 and not_purchasable:
  return {'status':'non_shop_evolution_not_buy_recipe','selected':'Do not construct a purchasable native recipe from catalogue from-link. Native RecipeItem is0; catalogue entry not purchasable.','mechanical_adoption_qualified':False}
 if status=='missing_or_not_numeric' and isinstance(row.get('native'),bool) and close(row['native'],row['catalogue']):
  return {'status':'packed_zero_one_numeric_representation','selected':'Native INIBIN boolean-typed0/1 and catalogue numeric0/1 preserved with explicit encoding','mechanical_adoption_qualified':False}
 return {'status':'open','selected':None,'mechanical_adoption_qualified':False,'reason':'Missing key, scalar/ranked inheritance, differing rank definition, total/per-hit semantics or range semantics requires precise additional evidence.'}
