# 第三方规则镜像

这里保存了 32 份第三方规则的“最后可用副本”。即使原作者停止维护、源仓库删除或原网址返回 404，只要本仓库仍在，已经提交到这里的副本仍可继续使用。

## 怎么使用

1. 先把包含这些文件的合并请求合并到 `master`。
2. 在下面两份配置中只选一份：
   - `RULE-SET.github.conf`：直接使用 GitHub 官方原始文件地址。
   - `RULE-SET.rawstatic.conf`：通过 rawstatic 访问，格式最接近原配置。
3. 把选中配置里的全部内容复制到 Surge 配置的 `[Rule]` 区域。
4. 确认配置中用到的策略组名称已经存在，例如 `X`、`Proxy`、`🎯Direct`、`Netflix`、`Telegram` 等。

不要同时使用两份配置，否则规则会重复。

### 成功标志

- Surge 更新规则时不再访问原作者仓库，而是访问 `xiaokuaile/Surge`。
- 规则列表能够成功下载，没有 404 或“规则格式错误”。
- GitHub 仓库的 Actions 页面中，`Sync mirrored rule sets` 显示绿色成功标记。

### 常见问题排查

- **自己的地址返回 404**：先确认合并请求已经合并到 `master`，仅创建分支还不够。
- **提示策略不存在**：策略名称必须与配置中的名称完全一致；按你的实际名称修改每行第三段。
- **GitHub 官方地址无法下载**：改用 `RULE-SET.rawstatic.conf`，但不要两份一起用。
- **每日同步失败**：旧副本不会被删除，仍可继续使用。打开对应的 Actions 运行记录，可以看到具体是哪个源站失效。
- **出现格式错误**：先恢复仓库中上一个可用版本，再检查最近一次自动更新的文件。

## 自动更新怎样保护旧副本

仓库每天检查一次上游。只有下载成功、文件非空、内容不是网页并且看起来像规则列表时，才会替换旧文件。源站删除、超时或返回错误网页时，仓库会保留最后一个可用版本。

## 来源与许可

每个文件的来源和对应策略记录在 `sources.tsv`。文件内容保持原样，版权仍属于原作者；这些文件不应被当作本仓库作者的原创内容。

- `blackmatrix7/ios_rule_script`：GPL v2，许可证副本位于 `licenses/blackmatrix7-GPL-2.0.txt`。
- `ACL4SSR/ACL4SSR`：CC BY-SA 4.0，许可证副本位于 `licenses/ACL4SSR-CC-BY-SA-4.0.txt`。
- `HotKids/Rules`、`nexitallyy/ProxyRules` 与 `naiixi.com`：检查时未找到明确的公开许可证。个人备份通常风险较低，但公开再发布前最好向原作者确认授权。

原 DivineEngine 仓库已经删除，原来的 Google 与 YouTube 地址会返回 404；这两份文件已改用 blackmatrix7 的对应规则，并在 `sources.tsv` 中保留说明。
