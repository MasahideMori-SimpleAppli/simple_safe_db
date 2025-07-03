enum EnumQueryType {
  add,
  update,
  updateOne,
  delete,
  search,
  conformToTemplate, // DB shape change.
  renameField, // DB field name change
  count, // get all items count.
  clear, // delete all items.
}
