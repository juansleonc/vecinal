module FoldersHelper

  def folder_tree_path(folder)
    links = [link_to(t('folders.home'), folders_path)]
    if folder.father
      links << '...' if folder.father.father
      links << link_to(folder.father.name, folder.father)
    end
    links << ['<div>' + folder.name + '</div>']
    links.join(' <i class="fa fa-angle-right"></i> ').html_safe
  end

end
