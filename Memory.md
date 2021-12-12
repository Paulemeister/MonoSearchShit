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
|29.6|  padding                             |2.1|
|32|    char *name                          |8  |x
|40|    const char *assembly_name           |8  |x
|48|    const char *module_name             |8  |x
|56|    char *version                       |8  |x
|72|    ...


### _MonoAssembly
| offset | variable | varsize | size correct
| --- | --- | :---: | :---:
|0|     int ref_count                       |4  |
|4|     padding                             |4  |
|8|     char *basedir                       |8  |
|16|    MonoAssemblyName aname              |74 |
|90|    padding                             |6  |
|96|    MonoImage *image;                   |8  |
|104|   ...

### _MonoAssemblyName
size: 74 Byte; 
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