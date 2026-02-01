# macOS system management aliases
# Main commands are scripts in ~/.dotfiles/bin/mac/:
#   - aerospace: reload | restart | stop (AeroSpace + borders)
#   - sketchybar: reload | stop
#   - apply-window-manager: Apply ~/.env.local (DISABLE_AEROSPACE, DISABLE_SKETCHYBAR)
#   - eborders: Edit borders config
#   - borders-logs: View borders error logs

# Helper aliases only
alias list-agents="launchctl list | grep -v com.apple"
