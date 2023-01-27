def is_resource_group(file)
    extname= file[/\.[^\.]+$/]
    if extname == '.bundle' || extname == '.xcassets' then
        return true
    end
    return false
end

def add_files_togroup(project, target, group)

    if File.exist?(group.real_path)

        Dir.foreach(group.real_path) do |entry|
            filePath = File.join(group.real_path, entry)

            # puts filePath

            if filePath.to_s.end_with?(".DS_Store", ".xcconfig") then
                # ignore

            elsif filePath.to_s.end_with?(".lproj") then
                if @variant_group.nil?
                    @variant_group = group.new_variant_group("Localizable.strings");
                end
                string_file = File.join(filePath, "Localizable.strings")
                fileReference = @variant_group.new_reference(string_file)
                target.add_resources([fileReference])

            elsif is_resource_group(entry) then
                fileReference = group.new_reference(filePath)
                target.add_resources([fileReference])
            elsif !File.directory?(filePath) then

                # 向group中增加文件引用
                fileReference = group.new_reference(filePath)
                # 如果不是头文件则继续增加到Build Phase中
                if filePath.to_s.end_with?(".m", ".mm", ".cpp") then
                    target.add_file_references([fileReference])
            # elsif filePath.to_s.end_with?("pbobjc.m", "pbobjc.mm") then
                    # target.add_file_references([fileReference], '-fno-objc-arc')

                elsif filePath.to_s.end_with?(".pch") then

                elsif filePath.to_s.end_with?("Info.plist") && entry == "Info.plist" then

                elsif filePath.to_s.end_with?(".h") then
                    # target.headers_build_phase.add_file_reference(fileReference)
                elsif filePath.to_s.end_with?(".framework") || filePath.to_s.end_with?(".a") then
                    target.frameworks_build_phases.add_file_reference(fileReference)
                elsif
                    target.add_resources([fileReference])
                end
            # 目录情况下, 递归添加
            elsif File.directory?(filePath) && entry != '.' && entry != '..' then

                subGroup = group.find_subpath(entry, true)
                subGroup.set_source_tree(group.source_tree)
                subGroup.set_path(File.join(group.real_path, entry))
                add_files_togroup(project, target, subGroup)

            end
        end
    end
end

puts "hola"

new_project_obj = Xcodeproj::Project.open(new_proj_fullname)

# new_proj_target = new_project_obj.new_target(:application, "Targetname", :ios, "9.0", nil, :objc)

# new_group = new_project_obj.main_group.find_subpath("GroupName", true)
