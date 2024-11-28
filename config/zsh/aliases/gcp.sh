
alias gcloud-active='gcloud config configurations list --filter="is_active:true"'
alias gcloud-active-all='echo "Active Configuration:" && gcloud config configurations list --filter="is_active:true" && echo "Details:" && gcloud config list'
