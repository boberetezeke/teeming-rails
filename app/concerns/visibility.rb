module Visibility
  VISIBILITY_SHOW_ALL =      'show_all'
  VISIBILITY_SHOW_CHAPTER =  'show_chapter'
  VISIBILITY_HIDE_ALL =     'hide_all'
  VISIBILITY_HIDE_CHAPTER = 'hide_chapter'

  VISIBILITIES_HASH = {
    "Show on all dashboards"    => VISIBILITY_SHOW_ALL,
    "Show on chapter dashboard" => VISIBILITY_SHOW_CHAPTER,
    "Hide on all dashboards"    => VISIBILITY_HIDE_ALL,
    "Hide on chapter dashboard" => VISIBILITY_HIDE_CHAPTER
  }
end