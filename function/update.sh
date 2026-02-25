source ${HOME}/Endm/config/config.sh
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
PINK='\e[1;35m'
LIGHT_BLUE='\e[0;34m'  
LIGHT_GREEN='\e[0;32m' 
RES='\e[0m'
ERROR="[${RED}错误${RES}]:"
WORRY="[${YELLOW}警告${RES}]:"
SUSSEC="[${GREEN}成功${RES}]:"
INFO="[${BLUE}信息${RES}]:"
declare -A arch_map=(["aarch64"]="arm64" ["armv7l"]="armhf" ["x86_64"]="amd64")
archurl="${arch_map[$(uname -m)]}"
log() {
	local fileName="${HOME}/Endm/log.log"
	local fileMaxLen=100
	local fileDeleteLen=10
	if test $fileName; then
		echo "[$(date +%y/%m/%d-%H:%M:%S)]:$*" >>$fileName
		loglen=$(grep -c "" $fileName)
		if [ $loglen -gt $fileMaxLen ]; then
			sed -i '1,'$fileDeleteLen'd' $fileName
		fi
	else
		echo "[$(date +%y/%m/%d-%H:%M:%S)]:$*" >$fileName
	fi
}
A_DIR="${HOME}/Endm"
B_DIR="${HOME}/.back"
TEMP_DIR="${HOME}/.TEMP"
REMOTE_URL="${rawgit}config/version"
LOCAL_VERSION_FILE="${HOME}/Endm/config/version"
log 清理临时目录
rm -rf $TEMP_DIR
if [ -f "$LOCAL_VERSION_FILE" ]; then
	LOCAL_VERSION=$(cat "$LOCAL_VERSION_FILE" | jq -r .version)
else
	echo -e "${ERROR} 本地版本文件不存在，无法进行版本比较！"
	exit 1
fi
clear
echo -e "${INFO} 正在获取最新版本信息..."
log "更新源信息:$RESPONSE"
log "更新地址: $REMOTE_URL"
RESPONSE=$(curl --connect-timeout 10 -s $REMOTE_URL)
if [ $? -ne 0 ]; then
	echo -e "${WORRY} 无法获取版本信息，请检查你的网络环境"
	exit 1
fi
REMOTE_VERSION=$(echo $RESPONSE | jq -r .version)
GIT_CLONE=$(echo $RESPONSE | jq -r .git_clone)
DESCRIPTION=$(echo $RESPONSE | jq -r .description)
log "本地版本: $LOCAL_VERSION"
log "云端版本: $REMOTE_VERSION"
log "公告: $DESCRIPTION"
if [ "$(printf '%s\n' "$REMOTE_VERSION" "$LOCAL_VERSION" | sort -V | tail -n1)" != "$LOCAL_VERSION" ]; then
	echo -e "\n${BLUE}=========================================${RES}"
	echo -e "${LIGHT_BLUE}📌 版本检测结果${RES}"
	echo -e "${BLUE}=========================================${RES}"
	echo -e "${YELLOW}本地版本:${RES} ${LIGHT_GREEN}$LOCAL_VERSION${RES}"
	echo -e "${YELLOW}云端版本:${RES} ${GREEN}$REMOTE_VERSION${RES} (✨ 最新)"
	echo -e "${YELLOW}更新公告:${RES} ${LIGHT_BLUE}$DESCRIPTION${RES}"
	echo -e "${BLUE}=========================================${RES}\n"
	
	while true; do
		echo -e "${GREEN}❓ 发现新版本，是否立即更新？${RES}"
		echo -e "   ${YELLOW}[Y] 立即更新${RES}  |  ${RED}[N] 暂不更新${RES}"
		echo -e -n "${BLUE}请输入选择 (Y/N): ${RES}"
		read CHOICE
		case "$CHOICE" in
			[yY]) 
				echo -e "\n${GREEN}你选择了立即更新，准备启动更新流程...${RES}\n"
				log 用户选择立即更新
				break
				;;
			[nN]) 
				echo -e "\n${YELLOW}你选择了暂不更新，将保留当前版本${RES}"
				log 用户选择暂不更新，跳过更新流程
				exit 0
				;;
			*) 
				echo -e "\n${RED}输入无效！请仅输入 Y 或 N${RES}\n"
				log 用户输入无效选择，重新询问
				;;
		esac
	done

	log 进行git克隆
	echo -e "${INFO}正在下载更新..."
	if git clone --depth 1 ${git}$GIT_CLONE $TEMP_DIR ; then
	    log 仓库拉取成功
	else
		rm -rf $TEMP_DIR
	    git config --global http.postBuffer 524288000
	    git config --global http.maxRequestBuffer 100M
		log 设置缓冲区
		log 重新拉取
		git clone --depth 1 ${git}$GIT_CLONE $TEMP_DIR
	fi
	if [ $? -ne 0 ]; then
		echo -e "${ERROR} 更新失败，请检查网络环境后再重试，如仍有问题，请联系开发者！"
		sleep 2
		log 拉取失败
		rm -rf $TEMP_DIR
		exit 1
	fi
	echo -e "${INFO}备份当前A分区..."
	log 创建备份的 tar.gz 压缩包
	log "BACKUP_FILE=".back/backup_$(date +%Y%m%d_%H%M%S)_${LOCAL_VERSION}_to_${REMOTE_VERSION}.tar.gz""
	BACKUP_FILE=".back/backup_$(date +%Y%m%d_%H%M%S)_${LOCAL_VERSION}_to_${REMOTE_VERSION}.tar.gz"
	log "正在创建备份的压缩文件: $BACKUP_FILE"
	if ! tar -czf "$BACKUP_FILE" -C "$HOME" Endm; then
		echo -e "${ERROR}备份失败！"
	fi
	log 更新A分区
	echo -e "${INFO}更新A分区..."
	rm -rf $A_DIR/*
	cp -r $TEMP_DIR/* $A_DIR/
	log 清理临时目录
	rm -rf $TEMP_DIR
	if [ "${qqBot}" != "" ]; then
		Modify_the_variable qqBot ${qqBot} ${HOME}/Endm/config/config.sh
	fi
	chmod 777 ${HOME}/Endm/endm.sh
	
	clear
	echo -e "${GREEN}=========================================${RES}"
	echo -e "${LIGHT_GREEN}🎉 更新完成！${RES}"
	echo -e "${YELLOW}提示：每次更新重启脚本后，需先退出脚本再重新执行并选择更新地址${RES}"
	echo -e "\n${GREEN}=========================================${RES}"
	echo -e -n "${INFO}🚀 脚本即将重启... "
	for i in 4 3 2 1; do
	    sleep 1
	    echo -e -n "\b\b${RED}$i${RES} "
	done
	
	clear
	log 5秒原地倒计时结束，脚本即将重启
	exit
	exec ${HOME}/Endm/endm.sh
else
	echo -e "${GREEN}✅ 当前已是最新版本（$LOCAL_VERSION），无需更新！${RES}"
	sleep 1
	clear
	log 已是最新版本
fi
