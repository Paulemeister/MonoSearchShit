1 = 1 Byte

0.1 = 1 Bit

8*0.1 = 1

1. global variable: static GList *loaded_assemblies
    - known somehow as an offset from the function mono_assembly_foreach, as it's used in there(mov    rdi,QWORD PTR [rip+0x3f2f9a])
    - rdi is the next instruction, at this instruction it is 29
2. get to the loaded_assemblies by dereferencing
    - now inside a GList linked list (see below for offsets)
3. loaded_assemblies->data points to a MonoAssembly
4. loaded_assemlbies->data->image points to a MonoImage
5. loaded_assemlbies->data->image->assembly_name


MonoImage.class_cache->table points to array of MonoClass pointers?

Check: loaded_assemlbies->data->image->class_cache.table->name actually class name?

Checked: True

- *_MonoImage.module_name: System.Xml
    - _MonoImage.module_name (0x28=40)
        - _MonoImage

### _MonoImage

| offset | variable | varsize | size manually checked
| --- | --- | :---: | :---:
|0|     int ref_count                       |4  |
|4|     padding                             |4  |
|8|     void *raw_data_handle               |8  |
|16|    char *raw_data                      |8  |
|24|    guint32 raw_data_len                |4  |
|28|    guint8 raw_buffer_used : 1          |0.1|
|28.1|  guint8 raw_data_allocated : 1       |0.1|
|28.2|  guint8 fileio_used : 1              |0.1|
|28.3|  guint8 dynamic : 1                  |0.1|
|28.4|  guint8 ref_only : 1                 |0.1|
|28.5|  guint8 uncompressed_metadata : 1    |0.1|
|28.6|  guint8 metadata_only : 1            |0.1|
|28.7|  guint8 load_from_context : 1        |0.1|
|29|    guint8 checked_module_cctor : 1     |0.1|
|29.1|  guint8 has_module_cctor : 1         |0.1|
|29.2|  guint8 idx_string_wide : 1          |0.1|
|29.3|  guint8 idx_guid_wide : 1            |0.1|
|29.4|  guint8 idx_blob_wide : 1            |0.1|
|29.5|  guint8 core_clr_platform_code : 1   |0.1|
|29.6|  padding                             |2.2|
|32|    char *name                          |8  |x
|40|    const char *assembly_name           |8  |x
|48|    const char *module_name             |8  |x
|56|    char *version                       |8  |x
|64|    gint16 md_version_major             |2  |
|66|    gint16 md_version_minor             |2  |
|68|    char *guid                          |1  |
|69|    padding                             |3  |
|72|    char *guid                          |8  |
|80|    void *image_info                    |8  |
|88|    MonoMemPool *mempool                |8  |
|96|    char *raw_metadata                  |8  |
|104|   MonoStreamHeader heap_strings       |16 |
|120|   MonoStreamHeader heap_us            |16 |
|136|   MonoStreamHeader heap_blob          |16 |
|152|   MonoStreamHeader heap_guid          |16 |
|168|   MonoStreamHeader heap_tables        |16 |
|184|   MonoStreamHeader heap_pdb           |16 |
|200|   const char *tables_base             |8  |
|208|   guint64 referenced_tables           |8  |
|216|   int *referenced_table_rows          |8  |
|224|   MonoTableInfo tables [56]           |56*16|
|1120|  MonoAssembly **references           |8  |
|1128|  int nreferences                     |4  |
|1132|  padding                             |4  |
|1136|  MonoImage **modules                 |8  |
|1144|  guint32 module_count                |4  |
|1148|  padding                             |4  |
|1152|  gboolean *modules_loaded            |8  |
|1160|  MonoImage **files                   |8  |
|1168|  guint32 file_count                  |4  |
|1172|  padding                             |4  |
|1176|  gpointer aot_module                 |8  |
|1184|  guint8 aotid[16]                    |1*16|
|1200|  MonoAssembly *assembly              |8  |
|1208|  GHashTable *method_cache            |8  |
|1216|  MonoInternalHashTable class_cache   |40 |
|1256|  ...


### _MonoAssembly
size: 128 Byte

alignement: 8 Byte
| offset | variable | varsize | size correct
| --- | --- | :---: | :---:
|0|     int ref_count                           |4  |
|4|     padding                                 |4  |
|8|     char *basedir                           |8  |
|16|    MonoAssemblyName aname                  |74 |
|90|    padding                                 |6  |
|96|    MonoImage *image;                       |8  |
|104|   GSList *friend_assembly_names           |8  |
|112|   guint8 friend_assembly_names_inited     |1  |
|113|   guint8 in_gac                           |1  |
|114|   guint8 dynamic                          |1  |
|115|   guint8 corlib_internal                  |1  |
|116|   gboolean ref_only                       |4  |
|120|   guint8 wrap_non_exception_throws        |1  |
|121|   guint8 wrap_non_exception_throws_inited |1  |
|122|   guint8 jit_optimizer_disabled           |1  |
|123|   guint8 jit_optimizer_disabled_inited    |1  |
|124|   guint32 ecma:2                          |0.2|
|124.2| guint32 aptc:2                          |0.2|
|124.4| guint32 fulltrust:2                     |0.2|
|124.6| guint32 unmanaged:2                     |0.2|
|125|   guint32 skipverification:2              |0.2|
|125.2| padding                                 |2.6|

### _MonoAssemblyName
size: 74 Byte

alignement: 8 Byte
| offset | variable | varsize | size correct
| --- | --- | :---: | :---:
|0|     const char *name                    |8  |
|8|     const char *culture                 |8  |
|16|    const char *hash_value              |8  |
|24|    const mono_byte* public_key;        |8  |
|32|    mono_byte public_key_token [17]     |17 |
|49|    padding                             |3  |
|52|    uint32_t hash_alg                   |4  |
|56|    uint32_t hash_len                   |4  |
|60|    uint32_t flags                      |4  |
|64|    uint16_t major                      |2  |
|66|    uint16_t minor                      |2  |
|68|    uint16_t build                      |2  |
|70|    uint16_t revision                   |2  |
|72|    uint16_t arch                       |2  |

### MonoStreamHeader
size: 16 Byte

alignement: 8 Byte
| offset | variable | varsize | size correct
| --- | --- | :---: | :---:
|0|     const char *data                    |8  |
|8|     guint32  size                       |4  |
|12|    padding                             |4  |

### _MonoTableInfo
size: 16 Byte

alignement: 8 Byte
| offset | variable | varsize | size correct
| --- | --- | :---: | :---:
|0|     const char *base                    |8  |
|8|     guint rows : 24                     |3  |
|11|    guint row_size : 8                  |1  |
|12|    guint32 size_bitfield               |4  |

### _MonoInternalHashTable
size: 40 Byte

alignement: 8 Byte
| offset | variable | varsize | size correct
| --- | --- | :---: | :---:
|0|     GHashFunc hash_func                         |8  |
|8|     MonoInternalHashKeyExtractFunc key_extract  |8  |
|16|    MonoInternalHashNextValueFunc next_value    |8  |
|24|    gint size                                   |4  |
|28|    gint num_entries                            |4  |
|32|    gpointer *table                             |8  |

### _MonoClass

| offset | variable | varsize | size correct
| --- | --- | :---: | :---:
|0|     MonoClass *element_class            |8  |
|8|     MonoClass *cast_class               |8  |
|16|    MonoClass **supertypes              |8  |
|24|    guint16 idepth                      |2  |
|26|    guint8 rank                         |1  |
|27|    padding                             |1  |
|28|    int instance_size                   |4  |
|32|    guint inited : 1                    |0.1|
|32.1|  guint size_inited : 1               |0.1|
|32.2|  guint valuetype : 1                 |0.1|
|32.3|  guint enumtype : 1                  |0.1|
|32.4|  guint blittable : 1                 |0.1|
|32.5|  guint unicode : 1                   |0.1|
|32.6|  guint wastypebuilder : 1            |0.1|
|32.7|  guint is_array_special_interface : 1|0.1|
|33|    guint8 min_align                    |1  |
|34|    guint packing_size : 4              |0.4|
|34.4|  guint ghcimpl : 1                   |0.1|
|34.5|  guint has_finalize : 1              |0.1|
|34.6|  guint marshalbyref : 1              |0.1|
|34.7|  guint contextbound : 1              |0.1|
|35|    guint delegate : 1                  |0.1|
|35.1|  guint gc_descr_inited : 1           |0.1|
|35.2|  guint has_cctor : 1                 |0.1|
|35.3|  guint has_references : 1            |0.1|
|35.4|  guint has_static_refs : 1           |0.1|
|35.5|  guint no_special_static_fields : 1  |0.1|
|35.6|  guint is_com_object : 1             |0.1|
|35.7|  guint nested_classes_inited : 1     |0.1|
|36|    guint class_kind : 3                |0.3|
|36.3|  guint interfaces_inited : 1         |0.1|
|36.4|  guint simd_type : 1                 |0.1|
|36.5|  guint has_finalize_inited : 1       |0.1|
|36.6|  guint fields_inited : 1             |0.1|
|36.7|  guint has_failure : 1               |0.1|
|37|    guint has_weak_fields : 1           |0.1|
|37.1|  padding                             |2.7|
|40|    MonoClass *parent                   |8  |
|48|    MonoClass *nested_in                |8  |
|56|    MonoImage *image                    |8  |
|64|    const char *name                    |8  |
|72|    const char *name_space              |8  |
|80|    guint32 type_token                  |4  |
|84|    int vtable_size                     |4  |
|88|    guint16 interface_count             |2  |
|90|    padding                             |2  |
|92|    guint32 interface_id                |4  |
|96|    guint32 max_interface_id            |4  |
|100|   guint16 interface_offsets_count     |2  |
|102|   padding                             |2  |
|104|   MonoClass **interfaces_packed       |8  |
|112|   guint16 *interface_offsets_packed   |8  |
|120|   guint8 *interface_bitmap            |8  |
|128|   MonoClass **interfaces              |8  |
|136|   union {int ...} sizes               |4  |
|138|   padding                             |6  |
|144|   MonoClassField *fields              |8  |
|152|   ...