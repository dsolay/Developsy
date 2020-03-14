alias art="php artisan"
alias artisan="php artisan"
alias cdump="composer dump-autoload -o"
alias composer:dump="composer dump-autoload -o"
alias db:reset="php artisan migrate:reset && php artisan migrate --seed"
alias dusk="php artisan dusk"
alias fresh="php artisan migrate:fresh"
alias migrate="php artisan migrate"
alias refresh="php artisan migrate:refresh"
alias rollback="php artisan migrate:rollback"
alias seed="php artisan db:seed"
alias serve="php artisan serve --quiet &"
alias cache:clear="php artisan route:clear && php artisan config:clear && php artisan config:cache && php artisan cache:clear"
alias route:list="php artisan route:list"

alias phpunit="./vendor/bin/phpunit"
alias pu="phpunit"
alias puf="phpunit --filter"
alias pud='phpunit --debug'

alias cc='codecept'
alias ccb='codecept build'
alias ccr='codecept run'
alias ccu='codecept run unit'
alias ccf='codecept run functional'

alias composer:autoload='composer run-script post-autoload-dump'
alias composer:env='composer run-script post-root-package-install'
alias composer:key='composer run-script post-create-project-cmd'
